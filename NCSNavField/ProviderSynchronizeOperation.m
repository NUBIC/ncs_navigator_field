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

@interface ProviderSynchronizeOperation () {
    
}
@property(atomic,assign) BOOL bThrewException;
@end

@implementation ProviderSynchronizeOperation

@synthesize ticket = _ticket;
@synthesize delegate = _delegate;

- (id) initWithServiceTicket:(CasServiceTicket*)ticket {
    _bThrewException=NO;
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
        NSException *ex = [[NSException alloc] initWithName:er reason:nil userInfo:nil];
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
    
    NSString* path = @"/api/v1/providers";
    
    NCSLog(@"Requesting data from %@", path);
    RKObjectLoader* loader = [objectManager objectLoaderWithResourcePath:path delegate:self];
    loader.method = RKRequestMethodGET;
    
    [loader sendSynchronously];
    return TRUE;
}

#pragma mark - RKObjectLoaderDelegate Methods

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    [_delegate showAlertView:PROVIDER_RETRIEVAL];
    NSException *ex = [[NSException alloc] initWithName:@"Retrieving providers" reason:nil userInfo:nil];
    @throw ex;

}


@end
