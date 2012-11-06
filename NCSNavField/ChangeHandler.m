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

-(id)initWithObject:(id)object field:(SEL)field {
    if (self = [super init]) {
        self.object = object;
        self.field = field;
    }
    return self;
}

- (void)updatedValue:(id)value {
    if ([self.object respondsToSelector:self.field]) {
        RKObjectPropertyInspector* i = [RKObjectPropertyInspector sharedInspector];
        Class type = [i typeForProperty:NSStringFromSelector(self.field) ofClass:[self.object class]];
        if (type == [NSNumber class]) {
            NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
            [f setNumberStyle:NSNumberFormatterDecimalStyle];
            NSNumber* tranformed = [value isKindOfClass:[NSString class]] ? [f numberFromString:value] : value;
            [self.object setValue:tranformed forKey:NSStringFromSelector(self.field)];
        } else {
            [self.object setValue:value forKey:NSStringFromSelector(self.field)];
        }
    } else {
        NCSLog(@"Failed to update '%@' on the class %@", NSStringFromSelector(self.field), NSStringFromClass([self.object class]));
    }
}

@end
