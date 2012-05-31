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
    CasProxyTicket* pt = [self obtainProxyTicket:self.ticket];
    return [self send:pt];
}

- (BOOL) isSuccessful {
    return !self.error;
}

- (BOOL)send:(CasProxyTicket*)proxyTicket {
    if (proxyTicket) {
        Fieldwork* submission = [Fieldwork submission];
        if (submission) {
            RKObjectManager *objectManager = [self objectManager:proxyTicket];
            RKObjectLoader* loader = [self objectLoader:submission objectManager:objectManager];
            self.response = [loader sendSynchronously];
            NCSLog(@"Response status code: %d", [self.response statusCode]);
        }
    }
    return [self isSuccessful];
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

- (RKObjectManager *)objectManager:(CasProxyTicket *)proxyTicket {
    RKObjectManager* objectManager = [RKObjectManager sharedManager];
    [objectManager.client.HTTPHeaders setValue:[NSString stringWithFormat:@"CasProxy %@", proxyTicket.proxyTicket] forKey:@"Authorization"];
    return objectManager;
}

- (RKObjectLoader *)objectLoader:(Fieldwork *)submission objectManager:(RKObjectManager *)objectManager {
    // TODO: Serialize data and then use RKRequest so objectLoader isn't 
    // invoked when data is returned
    RKObjectLoader* loader = [objectManager objectLoaderForObject:submission method:RKRequestMethodPUT delegate:self];
    return loader;
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error {
    NCSLog(@"Error: Localized Description: %@", [error localizedDescription]);
    NCSLog(@"Error: Underlying Error: %@", [error.userInfo valueForKey:NSUnderlyingErrorKey]);
    self.error = [NSString stringWithFormat:@"Error while pushing fieldwork.\n%@", [error localizedDescription]];
    [self showErrorMessage:self.error];

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
