//
//  RecieveFieldworkStep.h
//  NCSNavField
//
//  Created by John Dzak on 4/27/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FieldworkStepPostRequest : NSObject<RKObjectLoaderDelegate> {
    CasServiceTicket* _ticket;
    NSString* _error;
    RKResponse* _response;
}

@property(nonatomic,strong) CasServiceTicket* ticket;

@property(nonatomic,strong) NSString* error;

@property(nonatomic,strong) RKResponse* response;

- (id) initWithServiceTicket:(CasServiceTicket*)ticket;

- (BOOL) send;

- (BOOL) isSuccessful;

- (void)loadDataWithProxyTicket:(CasProxyTicket*)ticket;

- (void)retrieveContacts:(CasServiceTicket*)serviceTicket;

- (void)showErrorMessage:(NSString *)message;

@end
