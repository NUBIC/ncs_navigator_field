//
//  FieldworkSynchronizer.h
//  NCSNavField
//
//  Created by John Dzak on 4/27/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProviderSynchronizeOperation.h"
#import "FieldworkSynchronizationException.h"
#import "NSMutableString+Additions.h"
#import "NCSLoggingDelegate.h"

@class ProviderSynchronizeOperation;

@interface FieldworkSynchronizeOperation : NSObject {
    CasServiceTicket* _ticket;
    id<UserErrorDelegate> _userAlertDelegate;
    id<NCSLoggingDelegate> _loggingDelegate;
}
@property(nonatomic,strong) id<NCSLoggingDelegate> loggingDelegate;
@property(nonatomic,strong) id<UserErrorDelegate> userAlertDelegate;
@property(nonatomic,strong) CasServiceTicket* ticket;

- (id)initWithServiceTicket:(CasServiceTicket*)ticket;
- (BOOL)perform;

@end