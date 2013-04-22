//
//  CasTicketException.m
//  NCSNavField
//
//  Created by John Dzak on 4/22/13.
//  Copyright (c) 2013 Northwestern University. All rights reserved.
//

#import "CasTicketException.h"

@implementation CasTicketException

- (id)initWithReason:(NSString*)reason explanation:(NSString*)explanation {
    self = [self initWithName:@"FieldworkSynchronizationException" reason:reason userInfo:nil];
    if (self) {
        _explanation = explanation ? [NSString stringWithString:explanation] : nil;
    }
    return self;
}

@end
