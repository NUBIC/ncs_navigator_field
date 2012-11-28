//
//  EventTemplate.m
//  NCSNavField
//
//  Created by John Dzak on 10/29/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "EventTemplate.h"
#import "Instrument.h"
#import "Event.h"
#import "NSManagedObject+Additions.h"
#import "Participant.h"

NSInteger const PREGNANCY_SCREENING_EVENT_TYPE_CODE = 34;
NSInteger const PREGNANCY_VISIT_ONE_EVENT_TYPE_CODE = 13;

@implementation EventTemplate

@dynamic name;
@dynamic eventRepeatKey;
@dynamic eventTypeCode;
@dynamic instruments;

+ (EventTemplate*)pregnancyScreeningTemplate {
    return [EventTemplate findFirstByAttribute:@"eventTypeCode" withValue:[NSNumber numberWithInt:PREGNANCY_SCREENING_EVENT_TYPE_CODE]];
}

+ (Instrument*)pregnancyScreeningInstrument {
    return [[EventTemplate pregnancyScreeningTemplate].instruments objectAtIndex:0];
}

+ (EventTemplate*)pregnancyVisitOneTemplate {
    return [EventTemplate findFirstByAttribute:@"eventTypeCode" withValue:[NSNumber numberWithInt:PREGNANCY_VISIT_ONE_EVENT_TYPE_CODE]];
}

- (Event*)buildEventForParticipant:(Participant*)participant {
    Event* e = [Event object];
    NSArray* eventAttrs = [[[EventTemplate entityDescription] attributesByName] allKeys];
    for (NSString* attr in eventAttrs) {
        id value = [self valueForKey:attr];
        id eventHasAttribute = [[[Event entityDescription] attributesByName] objectForKey:attr];
        if (eventHasAttribute) {
            [e setValue:value forKey:attr];
        } else {
            NCSLog(@"Error: Attribute '%@' does not exist on event", attr);
        }
    }

    for (Instrument* i in self.instruments) {
        [e addInstrumentsObject:(Instrument*)[i clone]];
    }
    
    e.pId = participant.pId;

    return e;
}

@end
