//
//  PushFieldworkStep.m
//  NCSNavField
//
//  Created by John Dzak on 4/24/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "FieldworkPushStep.h"
#import "ApplicationSettings.h"
#import "Fieldwork.h"
#import "MergeStatus.h"
#import "CasServiceTicket+Additions.h"
#import "FieldworkSynchronizationException.h"
#import "CasTicketException.h"

@implementation FieldworkPushStep

@synthesize ticket = _ticket;

@synthesize error = _error;

@synthesize response = _response;
@synthesize delegate = _delegate;

- (id) initWithServiceTicket:(CasServiceTicket*)ticket {
    self = [super init];
    if (self) {
        _ticket = ticket;
    }
    return self;
}

- (BOOL)send {
    if (!self.ticket) {
        @throw [[FieldworkSynchronizationException alloc] initWithReason:@"Failed to retrieve contacts" explanation:@"Service ticket is nil"];
    }
    
    BOOL success = FALSE;
    
    @try {
        CasProxyTicket *pt = [self.ticket obtainProxyTicket];
        success = [self send:pt];
    }
    @catch (CasTicketException *te) {
        @throw [[FieldworkSynchronizationException alloc] initWithReason:CAS_TICKET_RETRIEVAL explanation:[NSString stringWithFormat:@"Failed to retrieve proxy ticket: %@", te.explanation]];
    }
    return success;
}

- (BOOL) isSuccessful {
    return !(self.error && [self.error length] > 0);
}

- (BOOL)send:(CasProxyTicket*)proxyTicket {
    if (!proxyTicket) {
        @throw [[FieldworkSynchronizationException alloc] initWithReason:CAS_TICKET_RETRIEVAL explanation:@"Proxy ticket is nil"];
    }
    BOOL success = false;
    if (proxyTicket) {
        Fieldwork* submission = [Fieldwork submission];
        if (submission) {
            RKObjectManager *objectManager = [self objectManager:proxyTicket];
            RKObjectLoader* loader = [self objectLoader:submission objectManager:objectManager];
            self.response = [loader sendSynchronously];
            NSLog(@"Put response has location header: %@", self.response.location);
            NSLog(@"Response status code: %d", [self.response statusCode]);
            success = [self isSuccessful];
        }
    }
    return success;
}

- (RKObjectManager *)objectManager:(CasProxyTicket *)proxyTicket {
    RKObjectManager* objectManager = [RKObjectManager sharedManager];
    [objectManager.client.HTTPHeaders setValue:[NSString stringWithFormat:@"CasProxy %@", proxyTicket.proxyTicket] forKey:@"Authorization"];
    [objectManager.client.HTTPHeaders setValue:ApplicationSettings.instance.clientId forKey:@"X-Client-ID"];
    return objectManager;
}

- (RKObjectLoader *)objectLoader:(Fieldwork *)submission objectManager:(RKObjectManager *)objectManager {
    // TODO: Serialize data and then use RKRequest so objectLoader isn't 
    // invoked when data is returned
    
    NSString* path = [NSString stringWithFormat:@"/api/v1/fieldwork/%@", submission.fieldworkId];
    
    NSLog(@"PUT %@", path);
    
    RKObjectLoader* loader = [objectManager loaderForObject:submission method:RKRequestMethodPUT];
    loader.delegate = self;
    loader.resourcePath = path;
    
    return loader;
}

- (NSString*) mergeStatusId {
    return [MergeStatus mergeStatusIdFromUri:self.response.location];
}

#pragma mark - 
#pragma RKDelegate


- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error {
    // We're only showing an error if the response failed because
    // upon success Cases will return a response with the body
    // {"success":true}, which is unmappable and causes RestKit to
    // throw an error.
    if (!objectLoader.response.isSuccessful) {
        @throw [[FieldworkSynchronizationException alloc] initWithReason:PUTTING_DATA_ON_SERVER explanation:[NSString stringWithFormat:@"Failed to push fieldwork:.\n%@", [error localizedDescription]]];
    }
}

- (void)objectLoaderDidFinishLoading:(RKObjectLoader*)objectLoader {
    //[_delegate showAlertView:@"the fieldwork step"];
}



@end
