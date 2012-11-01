//
//  EventTemplateTest.m
//  NCSNavField
//
//  Created by John Dzak on 11/1/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "EventTemplateTest.h"
#import "EventTemplate.h"
#import "Event.h"

@implementation EventTemplateTest

- (void)testBuildEvent {
    EventTemplate* tmpl = [EventTemplate object];
    tmpl.name = @"Cookie Cutter";
    tmpl.eventRepeatKey = [NSNumber numberWithInt:5];
    Event* actual = [tmpl buildEvent];
    STAssertEqualObjects(actual.name, @"Cookie Cutter", @"Wrong name");
    STAssertEqualObjects(actual.eventRepeatKey, [NSNumber numberWithInt:5], @"Wrong repeat key");
}

@end
