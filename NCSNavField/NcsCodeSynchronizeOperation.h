//
//  NcsCodeSynchronizeOperation.h
//  NCSNavField
//
//  Created by Sam Hicks on 11/19/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NcsCodeSynchronizeOperation : NSObject <RKObjectLoaderDelegate> {
    CasServiceTicket* _ticket;
}
@property(nonatomic,strong) CasServiceTicket* ticket;

- (id)initWithServiceTicket:(CasServiceTicket*)ticket;
- (void)perform;

@end
