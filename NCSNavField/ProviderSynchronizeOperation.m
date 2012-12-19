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
    if([er length]>0) {
        [_delegate showAlertView:CAS_TICKET_RETRIEVAL];
        FieldworkSynchronizationException *ex = [[FieldworkSynchronizationException alloc] initWithName:er reason:nil userInfo:nil];
        @throw ex;
    }
    else
       return [self sendRequestForProviders:pt];
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
    
    NCSLog(@"Requesting data from %@", path);
    RKObjectLoader* loader = [objectManager objectLoaderWithResourcePath:path delegate:self];
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
    [_delegate showAlertView:PROVIDER_RETRIEVAL];
    FieldworkSynchronizationException *ex = [[FieldworkSynchronizationException alloc] initWithName:@"Retrieving providers" reason:nil userInfo:nil];
    @throw ex;
}


@end
