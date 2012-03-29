//
//  PickerOptionTest.m
//  NCSNavField
//
//  Created by John Dzak on 11/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "PickerOptionTest.h"
#import "PickerOption.h"

@implementation PickerOptionTest

// All code under test must be linked into the Unit Test bundle
- (void)test_shouldBeInitializedProperly
{
    PickerOption* o = [[PickerOption alloc] initWithText:@"Red" value:1];
    STAssertEquals(@"Red", o.text, @"Wrong text");
    STAssertEquals(1, o.value, @"Wrong value");
}

@end
