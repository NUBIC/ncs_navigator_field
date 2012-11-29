//
//  FieldworkSynchronizer.h
//  NCSNavField
//
//  Created by John Dzak on 4/27/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProviderSynchronizeOperation.h"
@class ProviderSynchronizeOperation;

@interface FieldworkSynchronizeOperation : NSObject {
    CasServiceTicket* _ticket;
    id<UserErrorDelegate> delegate;
}

@property(nonatomic,strong) id<UserErrorDelegate> delegate;
@property(nonatomic,strong) CasServiceTicket* ticket;

- (id)initWithServiceTicket:(CasServiceTicket*)ticket;

- (BOOL)perform;

- (NSString*)submit;

- (BOOL)receive;

- (BOOL)poll:(NSString*)mergeStatusId;

@end