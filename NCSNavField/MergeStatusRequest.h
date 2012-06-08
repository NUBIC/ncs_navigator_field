//
//  MergeStatusRequest.h
//  NCSNavField
//
//  Created by John Dzak on 5/30/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MergeStatus;
@class ServiceTicket;

@interface MergeStatusRequest : NSObject {
    NSString* _mergeStatusId;
    NSString* _error;
    CasServiceTicket* _serviceTicket;
}

@property(nonatomic,retain) NSString* mergeStatusId;

@property(nonatomic,retain) NSString* error;

@property(nonatomic,retain) CasServiceTicket* serviceTicket;

- (id) initWithMergeStatusId:(NSString*)fieldworkId andServiceTicket:(CasServiceTicket*)serviceTicket;

- (MergeStatus*) send;

- (BOOL) poll;

- (void)showErrorMessage:(NSString *)message;

@end
