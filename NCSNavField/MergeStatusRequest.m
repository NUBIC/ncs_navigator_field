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
@synthesize delegate = _delegate;

- (id) initWithMergeStatusId:(NSString*)mergeStatusId andServiceTicket:(CasServiceTicket*)serviceTicket {
    self = [self init];
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
        [_delegate showAlertView:CAS_TICKET_RETRIEVAL];
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
            MergeStatus* ms = [MergeStatus parseFromJson:resp.bodyAsString];
            ms.mergeStatusId = self.mergeStatusId;
            ms.createdAt = [NSDate date];
            return ms;
        }
    }
    return nil;
}


- (BOOL) poll {
    
    for (int i=1; i <= POLL_REPEATS; i++) {
        MergeStatus* status = [self send];
        if (status) {
            if ([status isMerged] || [status isConflict] || [status isError]) {
                self.error = NULL;
                break;
            } else if ([status isPending] || [status isTimeout] || [status isWorking]) {
                self.error = @"It is taking slightly longer than expected to obtain your next contacts. Please try again a little later";
            } else { 
                self.error = @"There was an error preventing you from obtaining your next contacts. Please call the help desk";
            }
            [[MergeStatus currentContext] save:nil];
        }
        
        if (i != POLL_REPEATS) {
            [NSThread sleepForTimeInterval:5];
        }
    }
    if (self.error) {
        [_delegate showAlertView:MERGE_DATA];
        FieldworkSynchronizationException *ex = [[FieldworkSynchronizationException alloc] initWithName:self.error reason:nil userInfo:nil];
        @throw ex;
    }
    return TRUE;
}



#pragma mark RKRequestDelegate

- (void)request:(RKRequest *)request didFailLoadWithError:(NSError *)error {
    NSString* errorMsg = [NSString stringWithFormat:@"Problem checking merge status.\n%@", [error localizedDescription]];
    [_delegate showAlertView:MERGE_DATA];
    FieldworkSynchronizationException *ex = [[FieldworkSynchronizationException alloc] initWithName:errorMsg reason:nil userInfo:nil];
    @throw ex;
}

- (void)requestDidTimeout:(RKRequest *)request {
    [_delegate showAlertView:MERGE_DATA];
    FieldworkSynchronizationException *ex = [[FieldworkSynchronizationException alloc] initWithName:@"Merge status check timed out" reason:nil userInfo:nil];
    @throw ex;
}




@end
