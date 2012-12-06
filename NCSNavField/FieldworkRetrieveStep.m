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
#import "SBJsonWriter.h"
#import "ApplicationSettings.h"
#import "NSDate+Additions.h"
#import "CasServiceTicket+Additions.h"
#import "FieldworkSynchronizationException.h"

@interface FieldworkRetrieveStep() {
    BOOL _bRequestWorked;
}
@property (nonatomic,assign) BOOL bRequestWorked;

@end

@implementation FieldworkRetrieveStep

@synthesize userAlertDelegate = _userAlertDelegate;
@synthesize loggingDelegate = _loggingDelegate;
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
    NSString *err;
    CasProxyTicket *pt = [serviceTicket obtainProxyTicket:&err];
    if(err) {
        [_userAlertDelegate showAlertView:CAS_TICKET_RETRIEVAL];
        [_loggingDelegate addLine:LOG_AUTH_FAILED];
        [_loggingDelegate addLine:@"With Details:"];
        [_loggingDelegate addLine:err];
        FieldworkSynchronizationException *ex = [[FieldworkSynchronizationException alloc] initWithName:@"retrieving contacts failed because of CAS" reason:nil userInfo:nil];
        @throw ex;
    }
    else {
        [self loadDataWithProxyTicket:pt];
    }
}

- (void)loadDataWithProxyTicket:(CasProxyTicket*)ticket {
    // Load the object model via RestKit	
    RKObjectManager* objectManager = [RKObjectManager sharedManager];
    [objectManager.client.HTTPHeaders setValue:[NSString stringWithFormat:@"CasProxy %@", ticket.proxyTicket] forKey:@"Authorization"];
    [objectManager.client.HTTPHeaders setValue:ApplicationSettings.instance.clientId forKey:@"X-Client-ID"];
    
    NSDate* today = [NSDate date];
    NSInteger days = [[ApplicationSettings instance] upcomingDaysToSync];
    NSTimeInterval seconds = 60 * 60 * 24 * days;
    NSDate* inOneWeek = [today dateByAddingTimeInterval:seconds];
    
    NSString* path = [NSString stringWithFormat:@"/api/v1/fieldwork?start_date=%@&end_date=%@", [today toYYYYMMDD], [inOneWeek toYYYYMMDD]];
    
    NCSLog(@"Requesting data from %@", path);
    [_loggingDelegate addLine:[NSString stringWithFormat:@"Requesting data from %@", path]];
    //We need to do this on the main thread.
        RKObjectLoader* loader = [objectManager objectLoaderWithResourcePath:path delegate:self];
        loader.method = RKRequestMethodPOST;
        [loader sendSynchronously];
}

#pragma mark RKObjectLoaderDelegate

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
	NCSLog(@"Data loaded successfully [%@]", [[objectLoader response] location]);
   // [_loggingDelegate addLine:[NSString stringWithFormat:@"Data loaded successfully [%@]", [[objectLoader response] location]]];
    Fieldwork* w = [Fieldwork object];
    w.uri = [[objectLoader response] location];
    w.retrievedDate = [NSDate date];
    
    NSError *error = [[NSError alloc] init];
    if (![[RKObjectManager sharedManager].objectStore.managedObjectContextForCurrentThread save:&error]) {
        NCSLog(@"Error saving fieldwork location");
        //[_loggingDelegate addLine:@"Error saving fieldwork location"];
        [_userAlertDelegate showAlertView:STORING_CONTACTS];
        FieldworkSynchronizationException *ex = [[FieldworkSynchronizationException alloc] initWithName:@"Error saving fieldwork location" reason:nil userInfo:nil];
        @throw ex;
    }
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error {
    NSLog(@"%@",[error localizedDescription]);
    [_loggingDelegate addHeadline:LOG_RETRIEVE_DATA_NO];
    [_loggingDelegate addLineWithEmphasis:LOG_RETRIEVE_DATA_NO];
    [_loggingDelegate addLine:[error localizedDescription]];
    [_userAlertDelegate showAlertView:CONTACT_RETRIEVAL];
    FieldworkSynchronizationException *ex = [[FieldworkSynchronizationException alloc] initWithName:@"object Loader failure in Retrieving Contacts" reason:nil userInfo:nil];
    @throw ex;
}



@end
