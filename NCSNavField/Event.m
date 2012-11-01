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

@implementation Event

@dynamic eventId, name, eventTypeCode, eventTypeOther, eventRepeatKey, startDate, endDate, startTime, endTime, incentiveTypeId, incentiveCash, incentiveNonCash, dispositionId, dispositionCategoryId, breakOffId, comments, contact, instruments, version;

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

@end