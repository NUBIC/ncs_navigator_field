//
//  ProviderSynchronizeOperation.m
//  NCSNavField
//
//  Created by John Dzak on 11/7/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "ProviderSynchronizeOperation.h"
#import "CasServiceTicket.h"
#import "ApplicationSettings.h"
#import "CasServiceTicket+Additions.h"
#import "FieldworkSynchronizationException.h"

@interface ProviderSynchronizeOperation () {
    
}
@end

@implementation ProviderSynchronizeOperation

@synthesize ticket = _ticket;
@synthesize delegate = _delegate;

- (id) initWithServiceTicket:(CasServiceTicket*)ticket {
    self = [super init];
    if (self) {
        _ticket = ticket;
    }
    return self;
}

- (BOOL)perform {
    NSString *er;
    CasProxyTicket *pt = [self.ticket obtainProxyTicket:&er];
    if(er && [er length] > 0) {
        @throw [[FieldworkSynchronizationException alloc] initWithReason:CAS_TICKET_RETRIEVAL explanation:[NSString stringWithFormat:@"Failed to retrieve proxy ticket: %@", er]];
    }
    else {
       return [self sendRequestForProviders:pt];
    }
}

- (BOOL)sendRequestForProviders:(CasProxyTicket*)ticket {
    // Load the object model via RestKit
    RKObjectManager* objectManager = [RKObjectManager sharedManager];
    [objectManager.client.HTTPHeaders setValue:[NSString stringWithFormat:@"CasProxy %@", ticket.proxyTicket] forKey:@"Authorization"];
    [objectManager.client.HTTPHeaders setValue:ApplicationSettings.instance.clientId forKey:@"X-Client-ID"];
    
    NSString *strLastModified = [[ApplicationSettings instance] lastModifiedSinceForProviders];
    if([strLastModified length]>0) {
        [objectManager.client.HTTPHeaders setValue:strLastModified forKey:@"If-Modified-Since"];
    }
    
    NSString* path = @"/api/v1/providers";
    
    NSLog(@"Requesting data from %@", path);   
    RKObjectLoader* loader = [objectManager loaderWithResourcePath:path];
    loader.delegate = self;
    loader.method = RKRequestMethodGET;
    
    RKResponse *response = [loader sendSynchronously];
    if([response statusCode]==200) {
        NSString *strDate = [[NSDate date] lastModifiedFormat];
        [[ApplicationSettings instance] setLastModifiedSinceForProviders:strDate];
    }
    else if([response statusCode]==304) { //304
        NSLog(@"Pulling providers from cache!");
    }
    return TRUE;
}

#pragma mark - RKObjectLoaderDelegate Methods

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    @throw [[FieldworkSynchronizationException alloc] initWithReason:PROVIDER_RETRIEVAL explanation:[NSString stringWithFormat:@"Failed to retrieve providers: %@", [error localizedDescription]]];
}


@end
