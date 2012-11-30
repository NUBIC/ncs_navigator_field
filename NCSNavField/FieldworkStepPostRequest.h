//
//  RecieveFieldworkStep.h
//  NCSNavField
//
//  Created by John Dzak on 4/27/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProviderSynchronizeOperation.h"

@class ProviderSynchronizeOperation;
@interface FieldworkStepPostRequest : NSObject<RKObjectLoaderDelegate> {
    CasServiceTicket* _ticket;
    NSString* _error;
    RKResponse* _response;
    id<UserErrorDelegate> _delegate;
}

@property(nonatomic,strong) CasServiceTicket* ticket;

@property(nonatomic,strong) NSString* error;

@property(nonatomic,strong) RKResponse* response;
@property(nonatomic,strong) id<UserErrorDelegate> delegate;

- (id) initWithServiceTicket:(CasServiceTicket*)ticket;

- (BOOL) send;

- (BOOL) isSuccessful;

- (void)loadDataWithProxyTicket:(CasProxyTicket*)ticket;

- (void)retrieveContacts:(CasServiceTicket*)serviceTicket;

- (void)showErrorMessage:(NSString *)message;

@end
