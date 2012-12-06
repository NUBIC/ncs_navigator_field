//
//  NcsCodeSynchronizeOperation.h
//  NCSNavField
//
//  Created by Sam Hicks on 11/19/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProviderSynchronizeOperation.h" //Fix this later
#import "Diagnostics.h"

@class ProviderSynchronizeOperation;

@interface NcsCodeSynchronizeOperation : NSObject <RKObjectLoaderDelegate> {
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
