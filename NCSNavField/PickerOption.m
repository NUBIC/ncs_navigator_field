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

- (id) initWithText:(NSString*)t value:(NSObject*)v {
    if (self = [self init]) {
        self.text = t;
        self.value = v;
    }
    return self;
}


+ (PickerOption*) findWithValue:(NSObject*)val fromOptions:(NSArray*)options {
    for (PickerOption* o in options) {
        if ([o.value isEqual:val]) {
            return o;
        }
    }
    return NULL;
}

@end
