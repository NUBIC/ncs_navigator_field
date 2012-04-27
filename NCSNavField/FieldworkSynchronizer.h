//
//  FieldworkSynchronizer.h
//  NCSNavField
//
//  Created by John Dzak on 4/27/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FieldworkSynchronizer : NSObject {
    CasServiceTicket* _ticket;
}

@property(nonatomic,retain) CasServiceTicket* ticket;

- (id) initWithServiceTicket:(CasServiceTicket*)ticket;

- (void) perform;

@end
