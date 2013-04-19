//
//  FieldworkSynchronizationException.m
//  NCSNavField
//
//  Created by Sam Hicks on 11/30/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "FieldworkSynchronizationException.h"

@implementation FieldworkSynchronizationException

- (id)initWithReason:(NSString*)reason explanation:(NSString*)explanation {
    self = [self initWithName:@"FieldworkSynchronizationException" reason:reason userInfo:nil];
    if (self) {
        _explanation = [NSString stringWithString:explanation];
    }
    return self;
}

@end
