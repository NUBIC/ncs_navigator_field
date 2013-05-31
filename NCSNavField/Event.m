//
//  Event.m
//  NCSNavField
//
//  Created by John Dzak on 9/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Event.h"
#import "NSString+Additions.h"
#import "NSDate+Additions.h"
#import <NUSurveyor/NUUUID.h>
#import "Participant.h"

@interface Event ()

@end

@implementation Event

@dynamic eventId, name, eventTypeCode, eventTypeOther, eventRepeatKey, startDate, endDate, startTime, endTime, incentiveTypeId, incentiveCash, incentiveNonCash, dispositionCode, dispositionCategoryId, breakOffId, comments, contact, instruments, version, pId;

+ (Event*)event {
    Event* e = [Event object];
    e.eventId = [NUUUID generateUuidString];
    e.startDate = [NSDate date];
    e.startTime = [NSDate date];
    return e;
}

- (void) setStartTimeJson:(NSString*)startTime {
    self.startTime = [startTime jsonTimeToDate];
}

- (NSString*) startTimeJson {
    return [self.startTime jsonSchemaTime];
}

- (void) setEndTimeJson:(NSString*)endTime {
    self.endTime = [endTime jsonTimeToDate];
}

- (NSString*) endTimeJson {
    return [self.endTime jsonSchemaTime];
}

-(NSArray *)requiredProperties {
    return @[@"dispositionCode" , @"endTime"];
}

- (BOOL) completed {
    for (NSString *requiredObject in self.requiredProperties) {
        if ([self valueForKey:requiredObject] == nil) {
            return NO;
        }
    }
    return YES;
}

-(NSArray *)missingRequiredProperties {
    NSArray *missingRequiredPropertiesArray = @[];
    for (NSString *requiredObject in self.requiredProperties) {
        if ([self valueForKey:requiredObject] == nil) {
            missingRequiredPropertiesArray = [missingRequiredPropertiesArray arrayByAddingObject:requiredObject];
        }
    }
    return missingRequiredPropertiesArray;
}

- (NSNumber*)dispositionCodeNumber {
    NSNumber* result = nil;
    if (self.dispositionCode) {
        NSNumberFormatter* f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        result = [f numberFromString:self.dispositionCode];
    }
    return result;
}

- (Participant*)participant {
    return [Participant findFirstByAttribute:@"pId" withValue:self.pId];
}

// BUG: This is a workaround for a bug when using the generated method
//      addInstrumentsObject to add an instrument to the ordered set.
//      https://openradar.appspot.com/10114310
- (void)addInstrumentsObject:(Instrument *)value {
    NSMutableOrderedSet *temporaryInstruments = [self.instruments mutableCopy];
    [temporaryInstruments addObject:value];
    self.instruments = [NSOrderedSet orderedSetWithOrderedSet:temporaryInstruments];
}

@end