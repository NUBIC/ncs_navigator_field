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
        NSLog(@"Presenting service ticket");
        [self.ticket present];
    }
    NSString *error = [NSString new];
    CasProxyTicket *pt = [self.ticket obtainProxyTicket:&error];
    if(error && [error length]>0) {
        @throw [[FieldworkSynchronizationException alloc] initWithReason:NCS_CODE_RETRIEVAL explanation:[NSString stringWithFormat:@"Failed to retrieve proxy ticket: %@", error]];
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
    
    NSString *strLastModified = [[ApplicationSettings instance] lastModifiedSinceForCodes];
    if([strLastModified length]>0) {
        [objectManager.client.HTTPHeaders setValue:strLastModified forKey:@"If-Modified-Since"];
    }
    
    NSLog(@"Requesting data from %@", path);
    RKObjectLoader* loader = [objectManager loaderWithResourcePath:path];
    loader.delegate = self;
    loader.method = RKRequestMethodGET;
    
    RKResponse *response = [loader sendSynchronously];
    if(response.failureError) {
        @throw [[FieldworkSynchronizationException alloc] initWithReason:NCS_CODE_RETRIEVAL explanation:[response.failureError localizedDescription]];
    }
    if([response statusCode]==200) {
        NSString *strDate = [[NSDate date] lastModifiedFormat];
        [[ApplicationSettings instance] setLastModifiedSinceForCodes:strDate];
    }
    else if([response statusCode]==304) {
        NSLog(@"Pulling codes from cache!");
    }
    
}

#pragma mark - RKObjectLoaderDelegate Methods

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    @throw [[FieldworkSynchronizationException alloc] initWithReason:NCS_CODE_RETRIEVAL explanation:[error localizedDescription]];
}




@end
