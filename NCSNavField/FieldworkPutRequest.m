//
//  PushFieldworkStep.m
//  NCSNavField
//
//  Created by John Dzak on 4/24/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "FieldworkPutRequest.h"
#import "ApplicationSettings.h"
#import "Fieldwork.h"
#import "RestKit.h"

@implementation FieldworkPutRequest

@synthesize ticket = _ticket;

@synthesize error = _error;

@synthesize response = _response;

- (id) initWithServiceTicket:(CasServiceTicket*)ticket {
    self = [super init];
    if (self) {
        _ticket = [ticket retain];
    }
    return self;
}

- (BOOL) send {
    if (![self fieldworkExists]) {
        return true;
    }
    [self pushContacts:self.ticket];
    return [self isSuccessful];
}

- (BOOL) fieldworkExists {
    NSArray* all = [Fieldwork findAllSortedBy:@"retrievedDate" ascending:NO];
    return [all count] > 0;
}

- (BOOL) isSuccessful {
    return [self.response isSuccessful];
}

- (void)pushContacts:(CasServiceTicket*)serviceTicket {
    [serviceTicket present];
    if (serviceTicket.ok) {
        CasConfiguration* conf = [ApplicationSettings casConfiguration];
        CasClient* client = [[CasClient alloc] initWithConfiguration:conf];
        NSString* coreURL = [ApplicationSettings instance].coreURL;
        
        CasProxyTicket* t = [client proxyTicket:NULL serviceURL:coreURL proxyGrantingTicket:serviceTicket.pgt];
        [t reify];
        if (!t.error) {
            NCSLog(@"Proxy ticket successfully obtained: %@", t.proxyTicket);
            [self putDataWithProxyTicket:t];
        } else {
            self.error = [NSString stringWithFormat:@"Failed to obtain proxy ticket: %@", t.message];
            [self showErrorMessage:self.error];
        }
    } else {
        self.error = [NSString stringWithFormat:@"Presenting service ticket failed: %@", [serviceTicket message]];
        [self showErrorMessage:self.error];
    }
}

- (void)putDataWithProxyTicket:(CasProxyTicket*)proxyTicket {
    RKObjectManager* objectManager = [RKObjectManager sharedManager];
    [objectManager.client.HTTPHeaders setValue:[NSString stringWithFormat:@"CasProxy %@", proxyTicket.proxyTicket] forKey:@"Authorization"];
    
    NSArray* all = [Fieldwork findAllSortedBy:@"retrievedDate" ascending:NO];
    if ([all count] > 0) {
        Fieldwork* f = [all objectAtIndex:0];
        // TODO: Serialize data and then use RKRequest so objectLoader isn't invoked
        // when data is returned.
        RKObjectLoader* loader = [objectManager objectLoaderForObject:f method:RKRequestMethodPUT delegate:self];
        self.response = [loader sendSynchronously];
        NCSLog(@"Response status code: %d", [self.response statusCode]);

    }
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error {
    NCSLog(@"Expected loading to fail since there is no data returned. %@");
    NCSLog([self isSuccessful] ? @"Request is successful" : @"Request is not successful");
    NCSLog(@"Status code is %d", [self.response statusCode]);
    if (![self isSuccessful]) {
        self.error = [NSString stringWithFormat:@"Object loader error while pushing fieldwork.\n%@", [error localizedDescription]];
        [self showErrorMessage:self.error];
    }
}

- (void)objectLoaderDidFinishLoading:(RKObjectLoader*)objectLoader {
    NCSLog(@"Success");
}


- (void)showErrorMessage:(NSString *)message {
    NCSLog(@"%@", message);

    UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
    [alert show];
}

@end
