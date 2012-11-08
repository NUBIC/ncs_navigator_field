//
//  ProviderSynchronizeOperation.h
//  NCSNavField
//
//  Created by John Dzak on 11/7/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProviderSynchronizeOperation : NSObject<RKObjectLoaderDelegate> {
    CasServiceTicket* _ticket;
}

@property(nonatomic,strong) CasServiceTicket* ticket;

- (id) initWithServiceTicket:(CasServiceTicket*)ticket;

- (void)perform;

@end
