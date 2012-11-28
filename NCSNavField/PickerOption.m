//
//  PickerOption.m
//  NCSNavField
//
//  Created by John Dzak on 11/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "PickerOption.h"
#import "MdesCode.h"

@implementation PickerOption

@synthesize text,value,listName;

- (id) initWithText:(NSString*)t value:(NSInteger)v {
    if (self = [self init]) {
        self.text = t;
        self.value = [NSNumber numberWithInt:v];
    }
    return self;
}


+ (MdesCode*) findWithValue:(NSInteger)val fromOptions:(NSArray*)options {
    for (MdesCode* o in options) {
        if (o.localCode == [NSNumber numberWithInt:val]) {
            return o;
        }
    }
    return NULL;
}

+ (PickerOption*) po:(NSString*)text value:(NSInteger)val {
    return [[PickerOption alloc] initWithText:text value:val];
}

-(id)localCode {
    return @"";
}

@end
