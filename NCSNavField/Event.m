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
#import <NUSurveyor/UUID.h>

NSInteger const EVENT_TYPE_CODE_PBS_PARTICIPANT_ELIGIBILITY_SCREENING = 34;
NSInteger const EVENT_TYPE_CODE_PREGNANCY_VISIT_ONE = 13;

@implementation Event

@dynamic eventId, name, eventTypeCode, eventTypeOther, eventRepeatKey, startDate, endDate, startTime, endTime, incentiveTypeId, incentiveCash, incentiveNonCash, dispositionCode, dispositionCategoryId, breakOffId, comments, contact, instruments, version, pId;

+ (Event*)event {
    Event* e = [Event object];
    e.eventId = [UUID generateUuidString];
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

- (NSNumber*)dispositionCodeNumber {
    NSNumber* result = nil;
    if (self.dispositionCode) {
        NSNumberFormatter* f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        result = [f numberFromString:self.dispositionCode];
    }
    return result;
}

// BUG: This is a workaround for a bug when using the generated method
//      addInstrumentsObject to add an instrument to the ordered set.
//      https://openradar.appspot.com/10114310
- (void)addInstrumentsObject:(Instrument *)value {
    NSMutableOrderedSet *instruments = [[NSMutableOrderedSet alloc] initWithOrderedSet:self.instruments];
    [instruments addObject:value];
    self.instruments = instruments;
}
@end