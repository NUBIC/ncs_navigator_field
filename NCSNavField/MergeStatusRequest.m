//
//  MergeStatusRequest.m
//  NCSNavField
//
//  Created by John Dzak on 5/30/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "MergeStatusRequest.h"
#import "MergeStatus.h"
#import "NSURL+Extensions.h"
#import "ApplicationSettings.h"
#import "RKRequest+Additions.h"
#import "CasServiceTicket+Additions.h"
#import "FieldworkSynchronizationException.h"

@implementation MergeStatusRequest


const static NSInteger POLL_REPEATS = 3;

@synthesize mergeStatusId = _mergeStatusId;
@synthesize error = _error;
@synthesize serviceTicket = _serviceTicket;
@synthesize userAlertDelegate = _userAlertDelegate;
@synthesize loggingDelegate = _loggingDelegate;

- (id) initWithMergeStatusId:(NSString*)mergeStatusId andServiceTicket:(CasServiceTicket*)serviceTicket {
    self = [self init];
    backgroundQueue = dispatch_queue_create("edu.northwestern.www", NULL);
    if (self) {
        _mergeStatusId = mergeStatusId;
        _serviceTicket = serviceTicket;
    }
    return self;
}

- (NSURL*)resourceURL {
    NSString* coreURL = [[ApplicationSettings instance] coreURL];
    return [[[NSURL alloc] initWithString:coreURL] urlByAppendingPathComponent:[NSString stringWithFormat:@"/api/v1/merges/%@", self.mergeStatusId]];
}

- (MergeStatus*)send {
    NSString *error;
    CasProxyTicket *pt = [self.serviceTicket obtainProxyTicket:&error];
    if(error)
    {
        [_userAlertDelegate showAlertView:CAS_TICKET_RETRIEVAL];
        [_loggingDelegate addLine:LOG_AUTH_FAILED];
        FieldworkSynchronizationException *exServerDown = [[FieldworkSynchronizationException alloc] initWithName:@"CAS Server is down" reason:@"Server is down" userInfo:nil];
        @throw exServerDown;
    }
    if (pt) {
        RKRequest* req = [[RKRequest alloc] initWithURL:[self resourceURL]];
        req.delegate = self;
        req.method = RKRequestMethodGET;
        [req addAdditionalHeaders:pt];
        
        RKResponse* resp = [req sendSynchronously];
        if ([resp isSuccessful] && [resp isJSON]) {
            NSLog(@"Response body: %@", resp.bodyAsString);
            [_loggingDelegate addLine:[NSString stringWithFormat:@"Response body: %@", resp.bodyAsString]];
            MergeStatus* ms = [MergeStatus parseFromJson:resp.bodyAsString];
            ms.mergeStatusId = self.mergeStatusId;
            ms.createdAt = [NSDate date];
            return ms;
        }
    }
    return nil;
}
//Can we use NSTimers here? 
- (BOOL) poll {
    for (int i=1; i <= POLL_REPEATS; i++) {
        MergeStatus* status = [self send];
        if (status) {
            if ([status isMerged] || [status isConflict] || [status isError]) {
                [_loggingDelegate addLine:LOG_MERGING_YES];
                self.error = NULL;
                break;
            } else if ([status isPending] || [status isTimeout] || [status isWorking]) {
                //[_userAlertDelegate setHUDMessage:MERGE_IS_TAKING_TIME andDetailMessage:TRY_AGAIN_LATER withMajorFontSize:16.0];
                [_loggingDelegate addLine:LOG_MERGING_NO];
                self.error = MERGE_IS_TAKING_TIME;
            } else {
                //[_userAlertDelegate setHUDMessage:MERGE_IS_TAKING_TIME andDetailMessage:TRY_AGAIN_LATER withMajorFontSize:16.0];
                [_loggingDelegate addLine:LOG_MERGING_NO];
                self.error = MERGE_ERROR;
            }
            [[MergeStatus currentContext] save:nil];
        }
        
        if (i != POLL_REPEATS) {
            [NSThread sleepForTimeInterval:5];
        }
    }
    if (self.error) {
        [_loggingDelegate addLine:self.error];
        [_userAlertDelegate showAlertView:self.error];
        FieldworkSynchronizationException *ex = [[FieldworkSynchronizationException alloc] initWithName:self.error reason:nil userInfo:nil];
        @throw ex;
    }
    return TRUE;
}

#pragma mark RKRequestDelegate

- (void)request:(RKRequest *)request didFailLoadWithError:(NSError *)error {
    NSString* errorMsg = [NSString stringWithFormat:@"Problem checking merge status.\n%@", [error localizedDescription]];
    [_userAlertDelegate showAlertView:MERGE_DATA];
    FieldworkSynchronizationException *ex = [[FieldworkSynchronizationException alloc] initWithName:errorMsg reason:nil userInfo:nil];
    @throw ex;
}

- (void)requestDidTimeout:(RKRequest *)request {
    [_userAlertDelegate showAlertView:MERGE_DATA];
    FieldworkSynchronizationException *ex = [[FieldworkSynchronizationException alloc] initWithName:@"Merge status check timed out" reason:nil userInfo:nil];
    @throw ex;
}




@end
