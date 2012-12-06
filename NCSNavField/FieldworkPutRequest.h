//
//  PushFieldworkStep.h
//  NCSNavField
//
//  Created by John Dzak on 4/24/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProviderSynchronizeOperation.h"
#import "Diagnostics.h"

@class CasProxyTicket;
@class Fieldwork;

@interface FieldworkPutRequest : NSObject<RKObjectLoaderDelegate> {
    CasServiceTicket* _ticket;
    NSString* _error;
    RKResponse* _response;
    id<UserErrorDelegate> _userAlertDelegate;
    id<NCSLoggingDelegate> _loggingDelegate;
}

@property(nonatomic,strong) CasServiceTicket* ticket;

@property(nonatomic,strong) NSString* error;

@property(nonatomic,strong) RKResponse* response;

@property(nonatomic,strong) id<UserErrorDelegate> userAlertDelegate;
@property(nonatomic,strong) id<NCSLoggingDelegate> loggingDelegate;

- (id) initWithServiceTicket:(CasServiceTicket*)ticket;
- (BOOL) send;
- (BOOL) isSuccessful;
- (BOOL)send:(CasProxyTicket*)ticket;
- (RKObjectManager *)objectManager:(CasProxyTicket *)proxyTicket;
- (NSString*) mergeStatusId;
- (RKObjectLoader *)objectLoader:(Fieldwork *)submission objectManager:(RKObjectManager *)objectManager;
- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error;

@end
