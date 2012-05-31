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

@implementation MergeStatusRequest


const static NSInteger POLL_REPEATS = 3;

@synthesize fieldworkId = _fieldworkId;
@synthesize error = _error;
@synthesize serviceTicket = _serviceTicket;

- (id) initWithFieldworkId:(NSString*)fieldworkId andServiceTicket:(CasServiceTicket*)serviceTicket {
    self = [self init];
    if (self) {
        _fieldworkId = [fieldworkId retain];
        _serviceTicket = [serviceTicket retain];
    }
    return self;
}

- (NSURL*) resourceURL {
    NSString* coreURL = [[ApplicationSettings instance] coreURL];
    return [[[NSURL alloc] initWithString:coreURL] urlByAppendingPathComponent:[NSString stringWithFormat:@"/api/v1/merges/%@", self.fieldworkId]];
}

- (BOOL) poll {
    BOOL success = false;
    
    for (int i=1; i <= POLL_REPEATS; i++) {
        MergeStatus* status = [self send];
        if (status) {
            if ([status isMerged]) {
                success = true;
                self.error = NULL;
                break;
            } else if ([status isPending] || [status isTimeout] || [status isWorking]) {
                self.error = @"It is taking slightly longer than expected to obtain your next contacts. Please try again a little later";
            } else {
                self.error = @"There was an error preventing you from obtaining your next contacts. Please call the help desk";
            }
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
    CasProxyTicket* pt = [self obtainProxyTicket:self.serviceTicket];
    if (pt) {
        RKRequest* req = [[RKRequest alloc] initWithURL:[self resourceURL]];
        req.method = RKRequestMethodGET;
        NSMutableDictionary *headers = [NSMutableDictionary new];
        [headers setValue:@"application/json" forKey: @"Content-Type"];
        [headers setValue:[NSString stringWithFormat:@"CasProxy %@", pt.proxyTicket] forKey:@"Authorization"];
        req.additionalHTTPHeaders = headers;
        
        RKResponse* resp = [req sendSynchronously];
        if ([resp isOK] && [resp isJSON]) {
            NSLog(@"Response body: %@", resp.bodyAsString);
            return [MergeStatus parseFromJson:resp.bodyAsString];
        }
    }
    return nil;
}

- (void)showErrorMessage:(NSString *)message {
    NCSLog(@"%@", message);
    
    UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
    [alert show];
}

@end
