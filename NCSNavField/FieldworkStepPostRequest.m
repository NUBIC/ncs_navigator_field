//
//  RecieveFieldworkStep.m
//  NCSNavField
//
//  Created by John Dzak on 4/27/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "FieldworkStepPostRequest.h"
#import "ApplicationSettings.h"
#import "Fieldwork.h"
#import "Participant.h"
#import "Contact.h"
#import "InstrumentTemplate.h"
#import "SBJsonWriter.h"
#import "ApplicationSettings.h"
#import "NSDate+Additions.h"

@implementation FieldworkStepPostRequest

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
    [self retrieveContacts:self.ticket];
    return [self isSuccessful];
}

- (BOOL) isSuccessful {
    return [self.response isSuccessful];
}


- (void)retrieveContacts:(CasServiceTicket*)serviceTicket {
    if (serviceTicket.pgt) {
        CasConfiguration* conf = [ApplicationSettings casConfiguration];
        CasClient* client = [[CasClient alloc] initWithConfiguration:conf];
        NSString* coreURL = [ApplicationSettings instance].coreURL;
        
        NCSLog(@"Requesting proxy ticket");
        CasProxyTicket* t = [client proxyTicket:NULL serviceURL:coreURL proxyGrantingTicket:serviceTicket.pgt];
        [t reify];
        if (!t.error) {
            NCSLog(@"Proxy ticket successfully obtained: %@", t.proxyTicket);
            [self loadDataWithProxyTicket:t];
        } else {
            self.error = [NSString stringWithFormat:@"Failed to obtain proxy ticket: %@", t.message];
            [self showErrorMessage:self.error];

        }
    } else {
        NCSLog(@"Presenting service ticket");
        [serviceTicket present];
        if (serviceTicket.ok) {
            CasConfiguration* conf = [ApplicationSettings casConfiguration];
            CasClient* client = [[CasClient alloc] initWithConfiguration:conf];
            NSString* coreURL = [ApplicationSettings instance].coreURL;
            
            NCSLog(@"Requesting proxy ticket");
            CasProxyTicket* t = [client proxyTicket:NULL serviceURL:coreURL proxyGrantingTicket:serviceTicket.pgt];
            [t reify];
            if (!t.error) {
                NCSLog(@"Proxy ticket successfully obtained: %@", t.proxyTicket);
                [self loadDataWithProxyTicket:t];
            } else {
                self.error = [NSString stringWithFormat:@"Failed to obtain proxy ticket: %@", t.message];
                [self showErrorMessage:self.error];
            }
        } else {
            self.error = [NSString stringWithFormat:@"Presenting service ticket failed: %@", [serviceTicket message]];
            [self showErrorMessage:self.error];
        }
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
    NSString* clientId = [ApplicationSettings instance].clientId;
    
    NSString* path = [NSString stringWithFormat:@"/api/v1/fieldwork?start_date=%@&end_date=%@", [today toYYYYMMDD], [inOneWeek toYYYYMMDD]];
    
    
    NCSLog(@"Requesting data from %@", path);
    RKObjectLoader* loader = [objectManager objectLoaderWithResourcePath:path delegate:self];
    loader.method = RKRequestMethodPOST;
    
    [loader sendSynchronously];
}

#pragma mark RKObjectLoaderDelegate

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
    self.error = [NSString stringWithFormat:@"Object loader error while retrieving fieldwork.\n%@", [error localizedDescription]];
    [self showErrorMessage:self.error];
}


- (void)showErrorMessage:(NSString *)message {
    NCSLog(@"%@", message);
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}


@end
