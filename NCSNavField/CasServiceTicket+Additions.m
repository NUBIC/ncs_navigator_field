//
//  CasServiceTicket+Additions.m
//  NCSNavField
//
//  Created by Sam Hicks on 11/15/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "CasServiceTicket+Additions.h"
#import "ApplicationSettings.h"

@implementation CasServiceTicket (Additions)
- (CasProxyTicket*) obtainProxyTicket:(NSString*)error {
    CasProxyTicket* pt = NULL;
    if (!self.pgt) {
        [self present];
    }

    if (self.ok) {
        CasConfiguration* conf = [ApplicationSettings casConfiguration];
        CasClient* client = [[CasClient alloc] initWithConfiguration:conf];
        NSString* coreURL = [ApplicationSettings instance].coreURL;
        
        CasProxyTicket* pending = [client proxyTicket:NULL serviceURL:coreURL proxyGrantingTicket:self.pgt];
        [pending reify];
        if (!pending.error) {
            NCSLog(@"Proxy ticket successfully obtained: %@", pending.proxyTicket);
            pt = pending;
        } else {
            error = [NSString stringWithFormat:@"Failed to obtain proxy ticket: %@", pending.message];
        }
    } else {
        error = [NSString stringWithFormat:@"Presenting service ticket failed: %@", [self message]];
    }
    return pt;
}
@end
