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
#import "CasTicketException.h"

@implementation MergeStatusRequest

const static NSInteger LENGTH_TIME_BETWEEN_POLLS = 10;
const static NSInteger POLL_REPEATS = 12;

@synthesize mergeStatusId = _mergeStatusId;
@synthesize error = _error;
@synthesize serviceTicket = _serviceTicket;
@synthesize delegate = _delegate;

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
    if (!self.serviceTicket) {
        @throw [[FieldworkSynchronizationException alloc] initWithReason:@"Failed to retrieve contacts" explanation:@"Service ticket is nil"];
    }
    
    MergeStatus* status = nil;
    
    @try {
        CasProxyTicket *pt = [self.serviceTicket obtainProxyTicket];
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
            status = ms;
        }
    }
    @catch (CasTicketException *te) {
        @throw [[FieldworkSynchronizationException alloc] initWithReason:CAS_TICKET_RETRIEVAL explanation:[NSString stringWithFormat:@"Failed to retrieve proxy ticket: %@", te.explanation]];
    }
    return status;
}

- (BOOL) poll {
    for (int i=1; i <= POLL_REPEATS; i++) {
        MergeStatus* status = [self send];
        if (status) {
            if ([status isMerged] || [status isConflict] || [status isError]) {
                self.error = NULL;
                break;
            } else if ([status isPending] || [status isTimeout] || [status isWorking] || [status isSyncing]) {
                //dispatch_sync(dispatch_get_main_queue(),^ {
                    //[_delegate setHUDMessage:MERGE_IS_TAKING_TIME andDetailMessage:TRY_AGAIN_LATER withMajorFontSize:16.0];
                //} );
                self.error = MERGE_IS_TAKING_TIME;
            } else {
                //[_delegate setHUDMessage:MERGE_IS_TAKING_TIME andDetailMessage:TRY_AGAIN_LATER withMajorFontSize:16.0];
                self.error = MERGE_ERROR;
            }
            [[MergeStatus currentContext] save:nil];
        }
        else { //Merge timed out on the client side.
        self.error = MERGE_ERROR;
        }
    
        if (i != POLL_REPEATS) {
                [NSThread sleepForTimeInterval:LENGTH_TIME_BETWEEN_POLLS];
        }
    }
    if (self.error) {
        @throw [[FieldworkSynchronizationException alloc] initWithReason:self.error explanation:self.error];
    }
    return TRUE;
}

#pragma mark RKRequestDelegate

- (void)request:(RKRequest *)request didFailLoadWithError:(NSError *)error {
    @throw [[FieldworkSynchronizationException alloc] initWithReason:MERGE_DATA explanation:[NSString stringWithFormat:@"Failed to check merge status: %@", [error localizedDescription]]];
}

- (void)requestDidTimeout:(RKRequest *)request {
    @throw [[FieldworkSynchronizationException alloc] initWithReason:MERGE_DATA explanation:[NSString stringWithFormat:@"Merge status check timed out"]];
}




@end
