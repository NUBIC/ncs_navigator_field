//
//  ChangeHandler.m
//  NCSNavField
//
//  Created by John Dzak on 12/5/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ChangeHandler.h"

@implementation ChangeHandler

@synthesize object = _object;
@synthesize field = _field;

- (id) initWithObject:(id)object field:(SEL)field {
    if (self = [super init]) {
        self.object = object;
        self.field = field;
    }
    return self;
}

- (void) updatedValue:(id)value {
    if ([self.object respondsToSelector:self.field]) {
        [self.object setValue:value forKey:NSStringFromSelector(self.field)];
    }
}
@end
