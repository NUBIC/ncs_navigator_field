//
//  ProviderSynchronizeOperation.h
//  NCSNavField
//
//  Created by John Dzak on 11/7/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Diagnostics.h"

@interface ProviderSynchronizeOperation : NSObject<RKObjectLoaderDelegate> {
    CasServiceTicket* _ticket;
    id<UserErrorDelegate> _delegate;
    id<NCSLoggingDelegate> _loggingDelegate;
}

@property(nonatomic,strong) CasServiceTicket* ticket;
@property(nonatomic,strong) id<UserErrorDelegate> delegate;
@property(nonatomic,strong) id<NCSLoggingDelegate> loggingDelegate;

- (id)initWithServiceTicket:(CasServiceTicket*)ticket;
- (BOOL)perform;

@end
