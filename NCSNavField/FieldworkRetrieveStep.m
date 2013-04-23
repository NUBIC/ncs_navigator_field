//
//  RecieveFieldworkStep.m
//  NCSNavField
//
//  Created by John Dzak on 4/27/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "FieldworkRetrieveStep.h"
#import "ApplicationSettings.h"
#import "Fieldwork.h"
#import "Participant.h"
#import "Contact.h"
#import "InstrumentTemplate.h"
#import "ApplicationSettings.h"
#import "NSDate+Additions.h"
#import "CasServiceTicket+Additions.h"
#import "FieldworkSynchronizationException.h"
#import "CasTicketException.h"

@interface FieldworkRetrieveStep() {
    BOOL _bRequestWorked;
}
@property (nonatomic,assign) BOOL bRequestWorked;

@end

@implementation FieldworkRetrieveStep

@synthesize delegate = _delegate;
@synthesize ticket = _ticket;
@synthesize error = _error;
@synthesize response = _response;
@synthesize bRequestWorked = _bRequestWorked;

- (id)initWithServiceTicket:(CasServiceTicket*)ticket {
    self = [super init];
    if (self) {
        _ticket = ticket;
    }
    return self;
}

- (BOOL)send {
    [self retrieveContacts:self.ticket];
    return YES;
}

- (void)retrieveContacts:(CasServiceTicket*)serviceTicket {
    if (!serviceTicket) {
        @throw [[FieldworkSynchronizationException alloc] initWithReason:@"Failed to retrieve contacts" explanation:@"Service ticket is nil"];
    }
    
    @try {
        CasProxyTicket *pt = [self.ticket obtainProxyTicket];
        [self loadDataWithProxyTicket:pt];
    }
    @catch (CasTicketException *te) {
        @throw [[FieldworkSynchronizationException alloc] initWithReason:CAS_TICKET_RETRIEVAL explanation:[NSString stringWithFormat:@"Failed to obtain proxy ticket: %@", te.explanation]];
    }
}

- (void)loadDataWithProxyTicket:(CasProxyTicket*)ticket {
    if (!ticket) {
        @throw [[FieldworkSynchronizationException alloc] initWithReason:CAS_TICKET_RETRIEVAL explanation:@"Proxy ticket is nil"];
    }
    
    // Load the object model via RestKit
    RKObjectManager* objectManager = [RKObjectManager sharedManager];
    [objectManager.client.HTTPHeaders setValue:[NSString stringWithFormat:@"CasProxy %@", ticket.proxyTicket] forKey:@"Authorization"];
    [objectManager.client.HTTPHeaders setValue:ApplicationSettings.instance.clientId forKey:@"X-Client-ID"];
    
    NSDateComponents *daysComponent = [[NSDateComponents alloc] init];
    daysComponent.day = (0 - [[ApplicationSettings instance] pastDaysToSync]);
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate* pastDate = [calendar dateByAddingComponents:daysComponent toDate:[NSDate date] options:0];
    
    daysComponent.day = [[ApplicationSettings instance] upcomingDaysToSync];
    NSDate* futureDate = [calendar dateByAddingComponents:daysComponent toDate:[NSDate date] options:0];

    NSString* path = [NSString stringWithFormat:@"/api/v1/fieldwork?start_date=%@&end_date=%@", [pastDate toYYYYMMDD], [futureDate toYYYYMMDD]];
    
    NSLog(@"Requesting data from %@", path);
    RKObjectLoader* loader = [objectManager loaderWithResourcePath:path];
    loader.delegate = self;
    loader.method = RKRequestMethodPOST;
    
    [loader sendSynchronously];
}

#pragma mark RKObjectLoaderDelegate

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
	NSLog(@"Data retrieved successfully [%@]", [[objectLoader response] location]);
    
    Fieldwork* w = [Fieldwork object];
    w.uri = [[objectLoader response] location];
    w.retrievedDate = [NSDate date];
    
    NSError *error = [[NSError alloc] init];
    if (![[RKObjectManager sharedManager].objectStore.managedObjectContextForCurrentThread save:&error]) {
        @throw [[FieldworkSynchronizationException alloc] initWithReason:STORING_CONTACTS explanation:[NSString stringWithFormat:@"Failed to save fieldwork: %@", [error localizedDescription]]];
    }
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error {
    @throw [[FieldworkSynchronizationException alloc] initWithReason:CONTACT_RETRIEVAL explanation:[NSString stringWithFormat:@"Failed to retrieve fieldwork: %@", [error localizedDescription]]];
}



@end
