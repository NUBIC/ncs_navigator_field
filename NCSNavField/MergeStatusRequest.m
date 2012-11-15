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

@implementation MergeStatusRequest


const static NSInteger POLL_REPEATS = 3;

@synthesize mergeStatusId = _mergeStatusId;
@synthesize error = _error;
@synthesize serviceTicket = _serviceTicket;

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

- (BOOL) poll {
    BOOL success = false;
    
    for (int i=1; i <= POLL_REPEATS; i++) {
        MergeStatus* status = [self send];
        if (status) {
            if ([status isMerged] || [status isConflict] || [status isError]) {
                success = true;
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
        [self showErrorMessage:self.error];
    }
    
    return success;
}
//This exists in a category on CasServiceTicket, eventually move this functionality to the CAS project? 
- (CasProxyTicket*) obtainProxyTicket:(CasServiceTicket*)st {
    CasProxyTicket* pt = NULL;
    if (!st.pgt) {
        [st present];
    }
    if (st.ok) {
        CasConfiguration* conf = [ApplicationSettings casConfiguration];
        CasClient* client = [[CasClient alloc] initWithConfiguration:conf];
        NSString* coreURL = [ApplicationSettings instance].coreURL;
        
        CasProxyTicket* pending = [client proxyTicket:NULL serviceURL:coreURL proxyGrantingTicket:st.pgt];
        [pending reify];
        if (!pending.error) {
            NCSLog(@"Proxy ticket successfully obtained: %@", pending.proxyTicket);
            pt = pending;
        } else {
            self.error = [NSString stringWithFormat:@"Failed to obtain proxy ticket: %@", pending.message];
        }
    } else {
        self.error = [NSString stringWithFormat:@"Presenting service ticket failed: %@", [st message]];
    }
    return pt;
}

- (MergeStatus*) send {
    //We can also use this. I'm not 100% sure that this is the best solution, but it would be nice to save coding and have a single point
    //where this functionality is handled (easier when we want to make changes.) (See the one line directly below.)
    //CasProxyTicket *pt = [self.ticket obtainProxyTicket:self.error];
    CasProxyTicket* pt = [self obtainProxyTicket:self.serviceTicket];
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

#pragma mark RKRequestDelegate

- (void)request:(RKRequest *)request didFailLoadWithError:(NSError *)error {
    NSString* errorMsg = [NSString stringWithFormat:@"Problem checking merge status.\n%@", [error localizedDescription]];
    [self showErrorMessage:errorMsg];
}

- (void)requestDidTimeout:(RKRequest *)request {
    [self showErrorMessage:@"Merge status check timed out"];
}


- (void)showErrorMessage:(NSString *)message {
    NCSLog(@"%@", message);
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

@end
