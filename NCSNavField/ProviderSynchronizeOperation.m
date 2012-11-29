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
    BOOL _bThrewException;
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
    if (!self.ticket.pgt) {
        NCSLog(@"Presenting service ticket");
        [self.ticket present];
    }
    NSString *error = [NSString new];
    CasProxyTicket *pt = [self.ticket obtainProxyTicket:error];
    if([error length]>0) {
        [self showErrorMessage:error];
        return NO;
    }
    else
       return [self sendRequestAndLoadDataWithProxyTicket:pt];
}

- (BOOL)sendRequestAndLoadDataWithProxyTicket:(CasProxyTicket*)ticket {
    // Load the object model via RestKit
    RKObjectManager* objectManager = [RKObjectManager sharedManager];
    [objectManager.client.HTTPHeaders setValue:[NSString stringWithFormat:@"CasProxy %@", ticket.proxyTicket] forKey:@"Authorization"];
    [objectManager.client.HTTPHeaders setValue:ApplicationSettings.instance.clientId forKey:@"X-Client-ID"];
    
    NSString* path = @"/api/v1/providers";
    
    
    NCSLog(@"Requesting data from %@", path);
    RKObjectLoader* loader = [objectManager objectLoaderWithResourcePath:path delegate:self];
    loader.method = RKRequestMethodGET;
    
    [loader sendSynchronously];
    return !_bThrewException;
}

- (void)showErrorMessage:(NSString *)message {
    _bThrewException=YES;
    [_delegate showAlertView:@"the fetch for providers"];
}

#pragma mark - RKObjectLoaderDelegate Methods

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    _bThrewException=YES;
    [_delegate showAlertView:@"the fetch for providers"];

}


@end
