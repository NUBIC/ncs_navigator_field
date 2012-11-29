//
//  NcsCodeSynchronizeOperation.h
//  NCSNavField
//
//  Created by Sam Hicks on 11/19/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProviderSynchronizeOperation.h" //Fix this later
@class ProviderSynchronizeOperation;

@interface NcsCodeSynchronizeOperation : NSObject <RKObjectLoaderDelegate> {
    CasServiceTicket* _ticket;
    id<UserErrorDelegate> _delegate;
}
@property(nonatomic,strong) CasServiceTicket* ticket;
@property(nonatomic,strong) id<UserErrorDelegate> delegate;

- (id)initWithServiceTicket:(CasServiceTicket*)ticket;
- (BOOL)perform;

@end
