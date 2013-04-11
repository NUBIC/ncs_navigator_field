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
    EventTemplate *returnTemplate = nil;
    if ((returnTemplate = [EventTemplate findFirstByAttribute:@"name" withValue:EVENT_TEMPLATE_PBS_ELIGIBILITY])) { //check new
        return returnTemplate;
    }
    else {
        returnTemplate = [EventTemplate findFirstByAttribute:@"name" withValue:EVENT_TEMPLATE_PBS_ELIGIBILITY_LEGACY]; //check legacy
        return returnTemplate;
    }
}

+ (Instrument*)pregnancyScreeningInstrument {
    return [[EventTemplate pregnancyScreeningTemplate].instruments objectAtIndex:0];
}

+ (EventTemplate*)pregnancyVisitOneTemplate {
    EventTemplate *returnTemplate = nil;
    if ((returnTemplate = [EventTemplate findFirstByAttribute:@"name" withValue:EVENT_TEMPLATE_PREG_VISIT_ONE])) { //check new
        return returnTemplate;
    }
    else {
        returnTemplate = [EventTemplate findFirstByAttribute:@"name" withValue:EVENT_TEMPLATE_PREG_VISIT_ONE_LEGACY]; //check legacy
        return returnTemplate;
    }
}

+(EventTemplate *)birthCohortTemplate {
    EventTemplate *returnTemplate = [EventTemplate findFirstByAttribute:@"name" withValue:EVENT_TEMPLATE_BIRTH_COHORT];
    return returnTemplate;
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
            NSLog(@"Error: Attribute '%@' does not exist on event", attr);
        }
    }

    for (Instrument* i in self.instruments) {
        Instrument* cloned = [i clone];
        cloned.instrumentId = [NUUUID generateUuidString];
        [cloned createAndPopulateResponseSetsFromResponseTemplates:self.responseTemplates participant:participant person:person];
        [e addInstrumentsObject:cloned];
    }
    
    e.pId = participant.pId;

    return e;
}

-(void)addInstrumentsObject:(Instrument *)value {
    NSMutableOrderedSet *temporarySet = [self.instruments mutableCopy];
    [temporarySet addObject:value];
    self.instruments = [NSOrderedSet orderedSetWithOrderedSet:temporarySet];
}
@end
