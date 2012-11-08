//
//  ProviderSynchronizeOperation.m
//  NCSNavField
//
//  Created by John Dzak on 11/7/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "ProviderSynchronizeOperation.h"
#import "ApplicationSettings.h"

@implementation ProviderSynchronizeOperation

@synthesize ticket = _ticket;

- (id) initWithServiceTicket:(CasServiceTicket*)ticket {
    self = [super init];
    if (self) {
        _ticket = ticket;
    }
    return self;
}

- (void)perform {
    if (!self.ticket.pgt) {
        NCSLog(@"Presenting service ticket");
        [self.ticket present];
    }
    
    if (self.ticket.ok) {
        CasConfiguration* conf = [ApplicationSettings casConfiguration];
        CasClient* client = [[CasClient alloc] initWithConfiguration:conf];
        NSString* coreURL = [ApplicationSettings instance].coreURL;
        
        NCSLog(@"Requesting proxy ticket");
        CasProxyTicket* t = [client proxyTicket:NULL serviceURL:coreURL proxyGrantingTicket:self.ticket.pgt];
        [t reify];
        if (!t.error) {
            NCSLog(@"Proxy ticket successfully obtained: %@", t.proxyTicket);
            [self sendRequestAndLoadDataWithProxyTicket:t];
        } else {
            NSString* error = [NSString stringWithFormat:@"Failed to obtain proxy ticket: %@", t.message];
            [self showErrorMessage:error];
            
        }
    } else {
        NSString* error = [NSString stringWithFormat:@"Service ticket error: %@", [self.ticket message]];
            [self showErrorMessage:error];
    }
}

- (void)sendRequestAndLoadDataWithProxyTicket:(CasProxyTicket*)ticket {
    // Load the object model via RestKit
    RKObjectManager* objectManager = [RKObjectManager sharedManager];
    [objectManager.client.HTTPHeaders setValue:[NSString stringWithFormat:@"CasProxy %@", ticket.proxyTicket] forKey:@"Authorization"];
    [objectManager.client.HTTPHeaders setValue:ApplicationSettings.instance.clientId forKey:@"X-Client-ID"];
    
    NSString* path = @"/api/v1/providers";
    
    
    NCSLog(@"Requesting data from %@", path);
    RKObjectLoader* loader = [objectManager objectLoaderWithResourcePath:path delegate:self];
    loader.method = RKRequestMethodGET;
    
    [loader sendSynchronously];
}

- (void)showErrorMessage:(NSString *)message {
    NCSLog(@"%@", message);
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

#pragma mark - RKObjectLoaderDelegate Methods

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    NSString* msg = [NSString stringWithFormat:@"Object loader error while retrieving providers.\n%@", [error localizedDescription]];
    [self showErrorMessage:msg];

}


@end
