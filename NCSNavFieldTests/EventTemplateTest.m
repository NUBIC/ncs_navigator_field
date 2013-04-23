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
#import "Instrument.h"

@implementation EventTemplateTest

- (void)testBuildEvent {
    EventTemplate* tmpl = [EventTemplate object];
    tmpl.name = @"Cookie Cutter";
    tmpl.eventRepeatKey = [NSNumber numberWithInt:5];
    Event* actual = [tmpl buildEventForParticipant:nil person:nil];
    STAssertEqualObjects(actual.name, @"Cookie Cutter", @"Wrong name");
    STAssertEqualObjects(actual.eventRepeatKey, [NSNumber numberWithInt:5], @"Wrong repeat key");
}

- (void)testBuildEventWithInstrument {
    EventTemplate* tmpl = [EventTemplate object];
    
    Instrument* instrument = [Instrument object];
    instrument.name = @"Trumpet";
    [tmpl addInstrumentsObject:instrument];
    
    Event* actual = [tmpl buildEventForParticipant:nil person:nil];
    Instrument* actualInstrument = [[actual.instruments objectEnumerator] nextObject];
    STAssertEqualObjects(actualInstrument.name, @"Trumpet", @"Wrong name");
    STAssertTrue(actualInstrument.objectID != instrument.objectID, @"Instrument should be duplicated");    
}

- (void)testPregnancyScreeningTemplate {
    EventTemplate* t = [EventTemplate object];
    t.name = @"PBS-Eligibility";
    t.eventTypeCode = @34;
    STAssertEqualObjects([EventTemplate pregnancyScreeningTemplate], t, nil);
}

- (void)testPregnancyScreeningTemplateWhenNoneExists {
    STAssertNil([EventTemplate pregnancyScreeningTemplate], nil);
}

@end
