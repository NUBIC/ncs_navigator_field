//
//  NcsCodeSynchronizeOperation.m
//  NCSNavField
//
//  Created by Sam Hicks on 11/19/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "NcsCodeSynchronizeOperation.h"
#import "CasServiceTicket.h"
#import "ApplicationSettings.h"
#import "CasServiceTicket+Additions.h"

@implementation NcsCodeSynchronizeOperation

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
    [objectManager.client.HTTPHeaders setValue:@"application/json" forKey: @"Content-Type"];
    NSString* path = @"/api/v1/code_lists";
    
    NCSLog(@"Requesting data from %@", path);
    RKObjectLoader* loader = [objectManager objectLoaderWithResourcePath:path delegate:self];
    loader.method = RKRequestMethodGET;
    
    RKResponse *req = [loader sendSynchronously];
    if(req.failureError)
        return NO;
    else return YES;
}

- (void)showErrorMessage:(NSString *)message {
    [_delegate showAlertView:@"NCS retrieval"];
}

#pragma mark - RKObjectLoaderDelegate Methods

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    [_delegate showAlertView:@"NCS retrieval"];
    
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects
{
    NSLog(@"Number of objects returned %d",[objects count]);
}



@end
