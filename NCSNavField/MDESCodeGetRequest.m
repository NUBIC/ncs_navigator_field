//
//  MDESCodeGetRequest.m
//  NCSNavField
//
//  Created by Sam Hicks on 11/6/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "MDESCodeGetRequest.h"
#import "ApplicationSettings.h"
#import "Fieldwork.h"
#import "Participant.h"
#import "Contact.h"
#import "InstrumentTemplate.h"
#import "SBJsonWriter.h"
#import "ApplicationSettings.h"

@implementation MDESCodeGetRequest
@synthesize ticket = _ticket;
@synthesize error = _error;
@synthesize response = _response;

- (id) initWithServiceTicket:(CasServiceTicket*)ticket {
    self = [super init];
    if (self) {
        _ticket = ticket;
    }
    return self;
}

- (BOOL) send {
    CasProxyTicket *pt = [self obtainProxyTicket:self.ticket];
    [self retrieveCodes:pt];
    return [self isSuccessful];
}

- (BOOL)send:(CasProxyTicket*)proxyTicket {
    if (proxyTicket) {
        Fieldwork* submission = [Fieldwork submission];
        if (submission) {
            RKObjectManager *objectManager = [self objectManager:proxyTicket];
            RKObjectLoader* loader = [self objectLoader:submission objectManager:objectManager];
            self.response = [loader sendSynchronously];
            NSLog(@"Put response has location header: %@", self.response.location);
            NCSLog(@"Response status code: %d", [self.response statusCode]);
        }
    }
    return [self isSuccessful];
}

- (BOOL) isSuccessful {
    return [self.response isSuccessful];
}

- (CasProxyTicket*) obtainProxyTicket:(CasServiceTicket*)st {
    CasProxyTicket* pt = NULL;
    [st present];
    if (st.ok) {
        CasConfiguration* conf = [ApplicationSettings casConfiguration];
        CasClient* client = [[CasClient alloc] initWithConfiguration:conf];
        NSString* coreURL = [ApplicationSettings instance].coreURL;
        
        CasProxyTicket* pending = [client proxyTicket:NULL serviceURL:coreURL proxyGrantingTicket:st.pgt];
        [pending reify];
        if (!pending.error) {
            NCSLog(@"Proxy ticket successfully obtained: %@", pending.proxyTicket);
            [self loadDataWithProxyTicket:pending];
            pt = pending;
        } else {
            self.error = [NSString stringWithFormat:@"Failed to obtain proxy ticket: %@", pending.message];
        }
    } else {
        self.error = [NSString stringWithFormat:@"Presenting service ticket failed: %@", [st message]];
        [self showErrorMessage:self.error];
    }
    return pt;
}

- (void)loadDataWithProxyTicket:(CasProxyTicket*)ticket {
    // Load the object model via RestKit
    RKObjectManager* objectManager = [RKObjectManager sharedManager];
    //[objectManager.client.HTTPHeaders setValue:[NSString stringWithFormat:@"CasProxy %@", ticket.proxyTicket] forKey:@"Authorization"];
    
    NSDate* today = [NSDate date];
    NSInteger days = [[ApplicationSettings instance] upcomingDaysToSync];
    NSTimeInterval seconds = 60 * 60 * 24 * days;
    NSDate* inOneWeek = [today dateByAddingTimeInterval:seconds];
    NSString* clientId = [ApplicationSettings instance].clientId;
    
    NSDateFormatter* rfc3339 = [[NSDateFormatter alloc] init];
    [rfc3339 setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [rfc3339 setDateFormat:@"yyyy'-'MM'-'dd"];
    [rfc3339 setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    NSString* path = @"/api/v1/ncs_codes";    
    
    NCSLog(@"Requesting data from %@", path);
    RKObjectLoader* loader = [objectManager objectLoaderWithResourcePath:path delegate:self];
    loader.method = RKRequestMethodGET;
    
    [loader sendSynchronously];
}

- (RKObjectManager *)objectManager:(CasProxyTicket *)proxyTicket {
    RKObjectManager* objectManager = [RKObjectManager sharedManager];
    [objectManager.client.HTTPHeaders setValue:[NSString stringWithFormat:@"CasProxy %@", proxyTicket.proxyTicket] forKey:@"Authorization"];
    return objectManager;
}

- (RKObjectLoader *)objectLoader:(Fieldwork *)submission objectManager:(RKObjectManager *)objectManager {
    // TODO: Serialize data and then use RKRequest so objectLoader isn't
    // invoked when data is returned
    
    NSString* clientId = [ApplicationSettings instance].clientId;
    // NSString* path = [NSString stringWithFormat:@"/api/v1/fieldwork/%@?client_id=%@", submission.fieldworkId, clientId];
    NSString* path = [NSString stringWithFormat:@"/api/v1/fieldwork/"];
    [objectManager.client.HTTPHeaders setValue:clientId forKey:@"X-Client-ID"];
    NCSLog(@"GET %@", path);
    RKObjectLoader* loader = [objectManager objectLoaderForObject:submission method:RKRequestMethodGET delegate:self];
    loader.resourcePath = path;
    return loader;
}

- (void)retrieveCodes:(CasProxyTicket*)pt {
    // Load the object model via RestKit
    RKObjectManager* objectManager = [RKObjectManager sharedManager];
    NSString* clientId = [ApplicationSettings instance].clientId;
    [objectManager.client.HTTPHeaders setValue:clientId forKey:@"X-Client-ID"];
    
    NSDate* today = [NSDate date];
    /*NSInteger days = [[ApplicationSettings instance] upcomingDaysToSync];
    NSTimeInterval seconds = 60 * 60 * 24 * days;
    NSDate* inOneWeek = [today dateByAddingTimeInterval:seconds];*/
    
    
    NSDateFormatter* rfc3339 = [[NSDateFormatter alloc] init];
    [rfc3339 setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [rfc3339 setDateFormat:@"yyyy'-'MM'-'dd"];
    [rfc3339 setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    NSString* path = [NSString stringWithFormat:@"/api/v1/ncs_codes"];
    
    NCSLog(@"Requesting data from %@", path);
    
    RKObjectLoader* loader = [objectManager objectLoaderWithResourcePath:path delegate:self];
    loader.method = RKRequestMethodGET;
    
    [loader sendSynchronously];
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
	NCSLog(@"Data loaded successfully [%@]", [[objectLoader response] location]);
    
    Fieldwork* w = [Fieldwork object];
    w.uri = [[objectLoader response] location];
    w.retrievedDate = [NSDate date];
    w.participants = [[NSSet alloc] initWithArray:[objects filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"entity.name like %@", [[Participant entity] name ]]]];
    w.contacts = [[NSSet alloc] initWithArray:[objects filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"entity.name like %@", [[Contact entity] name ]]]];
    w.instrumentTemplates = [[NSSet alloc] initWithArray:[objects filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"entity.name like %@", [[InstrumentTemplate entity] name ]]]];
    
    NSError *error = [[NSError alloc] init];
    if (![[RKObjectManager sharedManager].objectStore.managedObjectContextForCurrentThread save:&error]) {
        NCSLog(@"Error saving fieldwork location");
    }
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error {
    self.error = [NSString stringWithFormat:@"Object loader error while retrieving MDES codes.\n%@", [error localizedDescription]];
    [self showErrorMessage:self.error];
}

- (void)showErrorMessage:(NSString *)message {
    NCSLog(@"%@", message);
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

- (NSURL*)resourceURL {
    NSString* coreURL = [[ApplicationSettings instance] coreURL];
    return [[[NSURL alloc] initWithString:coreURL] URLByAppendingPathComponent:@"/api/v1/ncs_codes/"];
}

@end
