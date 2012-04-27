//
//  PushFieldworkStep.h
//  NCSNavField
//
//  Created by John Dzak on 4/24/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CasProxyTicket;

@interface PushFieldworkStep : NSObject<RKObjectLoaderDelegate> {
    CasServiceTicket* _ticket;
    NSString* _error;
    RKResponse* _response;
}

@property(nonatomic,retain) CasServiceTicket* ticket;

@property(nonatomic,retain) NSString* error;

@property(nonatomic,retain) RKResponse* response;

- (id) initWithServiceTicket:(CasServiceTicket*)ticket;

- (void) perform;

- (BOOL) isSuccessful;

- (void)pushContacts:(CasServiceTicket*)serviceTicket;

- (void)putDataWithProxyTicket:(CasProxyTicket*)ticket;

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error;

@end
