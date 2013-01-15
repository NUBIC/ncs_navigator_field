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
#import <NUSurveyor/NUUUID.h>

@implementation EventTemplate

@dynamic name;
@dynamic eventRepeatKey;
@dynamic eventTypeCode;
@dynamic instruments;
@dynamic responseTemplates;

+ (EventTemplate*)pregnancyScreeningTemplate {
    return [EventTemplate findFirstByAttribute:@"eventTypeCode" withValue:[NSNumber numberWithInt:EVENT_TYPE_CODE_PBS_PARTICIPANT_ELIGIBILITY_SCREENING]];
}

+ (Instrument*)pregnancyScreeningInstrument {
    return [[EventTemplate pregnancyScreeningTemplate].instruments objectAtIndex:0];
}

+ (EventTemplate*)pregnancyVisitOneTemplate {
    return [EventTemplate findFirstByAttribute:@"eventTypeCode" withValue:[NSNumber numberWithInt:EVENT_TYPE_CODE_PREGNANCY_VISIT_ONE]];
}

- (Event*)buildEventForParticipant:(Participant*)participant person:(Person *)person {
    Event* e = [Event event];
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
        Instrument* cloned = (Instrument*)[i clone];
        cloned.instrumentId = [NUUUID generateUuidString];
        [cloned createAndPopulateResponseSetsFromResponseTemplates:self.responseTemplates participant:participant person:person];
        [e addInstrumentsObject:cloned];
    }
    
    e.pId = participant.pId;

    return e;
}

@end
