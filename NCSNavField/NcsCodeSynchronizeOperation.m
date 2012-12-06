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
#import "FieldworkSynchronizationException.h"

@interface NcsCodeSynchronizeOperation ()
-(void)sendRequestAndLoadDataWithProxyTicket:(CasProxyTicket*)ticket;
@end

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
    CasProxyTicket *pt = [self.ticket obtainProxyTicket:&error];
    if([error length]>0) {
        [_delegate showAlertView:NCS_CODE_RETRIEVAL];
        [_loggingDelegate addHeadline:LOG_AUTH_FAILED];
        [_loggingDelegate addLineWithEmphasis:LOG_AUTH_FAILED];
        FieldworkSynchronizationException *exception = [[FieldworkSynchronizationException alloc] initWithName:@"Cas error in NCS Code retrieval" reason:nil userInfo:nil];
        @throw exception;
    }
    else {
        [self sendRequestAndLoadDataWithProxyTicket:pt];
        return YES;
    }
}

- (void)sendRequestAndLoadDataWithProxyTicket:(CasProxyTicket*)ticket {
    // Load the object model via RestKit
    RKObjectManager* objectManager = [RKObjectManager sharedManager];
    [objectManager.client.HTTPHeaders setValue:[NSString stringWithFormat:@"CasProxy %@", ticket.proxyTicket] forKey:@"Authorization"];
    [objectManager.client.HTTPHeaders setValue:ApplicationSettings.instance.clientId forKey:@"X-Client-ID"];
    [objectManager.client.HTTPHeaders setValue:@"application/json" forKey: @"Content-Type"];
    NSString* path = @"/api/v1/code_lists";
    
    NCSLog(@"Requesting data from %@", path);
    //[_loggingDelegate addLine:LOG_RETRIEVE_PROVIDERS];
    //[_loggingDelegate addLine:[NSString stringWithFormat:@"Requesting data from %@", path]];
    RKObjectLoader* loader = [objectManager objectLoaderWithResourcePath:path delegate:self];
    loader.method = RKRequestMethodGET;
    [loader sendSynchronously];
}

#pragma mark - RKObjectLoaderDelegate Methods

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    [_delegate showAlertView:NCS_CODE_RETRIEVAL];
    [_loggingDelegate addLineWithEmphasis:LOG_MDES_RETRIEVE_NO];
    [_loggingDelegate addHeadline:LOG_MDES_RETRIEVE_NO];
    [_loggingDelegate addLine:[error localizedDescription]];
    FieldworkSynchronizationException *exception = [[FieldworkSynchronizationException alloc] initWithName:@"NCS Code Retrieval" reason:nil userInfo:nil];
    @throw exception;
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects
{
    //Diagnostics
    //This depdnds on the operations taking place sequentially and this coming last.
    [_loggingDelegate flush];
    NSLog(@"Number of objects returned %d",[objects count]);
}



@end
