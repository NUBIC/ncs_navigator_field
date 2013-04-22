//
//  CasServiceTicket+Additions.m
//  NCSNavField
//
//  Created by Sam Hicks on 11/15/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "CasServiceTicket+Additions.h"
#import "ApplicationSettings.h"
#import "ProviderSynchronizeOperation.h"
#import "CasTicketException.h"

@implementation CasServiceTicket (Additions)

/**
 *  Obtains a proxy ticket from the CAS server given a proxy
 *  granting ticket can be obtained.
 *
 *  @throws TicketException
 *
 **/
- (CasProxyTicket*) obtainProxyTicket {
    if (!self.pgt) {
        [self present];
        
        if (!self.ok) {
            @throw [[CasTicketException alloc] initWithReason:@"Failed when presenting service ticket" explanation:self.message];
        }
    }
    
    NSString* coreURL = [ApplicationSettings instance].coreURL;
    CasProxyTicket* pending = [[self casClient] proxyTicket:NULL serviceURL:coreURL proxyGrantingTicket:self.pgt];
    [pending reify];
    
    if (pending.error) {
        @throw [[CasTicketException alloc] initWithReason:@"Failed to obtain proxy ticket" explanation:pending.error];
    }
    
    return pending;
}

- (CasClient*) casClient {
    CasConfiguration* conf = [ApplicationSettings casConfiguration];
    return [[CasClient alloc] initWithConfiguration:conf];
}
@end
