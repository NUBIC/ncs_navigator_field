//
//  PushFieldworkStep.h
//  NCSNavField
//
//  Created by John Dzak on 4/24/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CasProxyTicket;
@class Fieldwork;

@interface FieldworkPutRequest : NSObject<RKObjectLoaderDelegate> {
    CasServiceTicket* _ticket;
    NSString* _error;
    RKResponse* _response;
}

@property(nonatomic,retain) CasServiceTicket* ticket;

@property(nonatomic,retain) NSString* error;

@property(nonatomic,retain) RKResponse* response;

- (id) initWithServiceTicket:(CasServiceTicket*)ticket;

- (BOOL) send;

- (BOOL) isSuccessful;

- (BOOL)send:(CasProxyTicket*)ticket;

- (CasProxyTicket*) obtainProxyTicket:(CasServiceTicket*)st;

- (RKObjectManager *)objectManager:(CasProxyTicket *)proxyTicket;

- (NSString*) mergeStatusId;

- (RKObjectLoader *)objectLoader:(Fieldwork *)submission objectManager:(RKObjectManager *)objectManager;

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error;

- (void)showErrorMessage:(NSString *)message;

@end
