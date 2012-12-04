//
//  MergeStatusRequest.h
//  NCSNavField
//
//  Created by John Dzak on 5/30/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProviderSynchronizeOperation.h"
@class MergeStatus;
@class ServiceTicket;

@interface MergeStatusRequest : NSObject<RKRequestDelegate> {
    NSString* _mergeStatusId;
    NSString* _error;
    CasServiceTicket* _serviceTicket;
    id<UserErrorDelegate> _delegate;
    dispatch_queue_t backgroundQueue;
}

@property(nonatomic,strong) NSString* mergeStatusId;

@property(nonatomic,strong) NSString* error;

@property(nonatomic,strong) CasServiceTicket* serviceTicket;

@property(nonatomic,strong) id<UserErrorDelegate> delegate;

- (id) initWithMergeStatusId:(NSString*)fieldworkId andServiceTicket:(CasServiceTicket*)serviceTicket;

- (MergeStatus*) send;

- (BOOL) poll;


@end
