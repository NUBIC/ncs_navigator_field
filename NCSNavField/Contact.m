//
//  Contact.m
//  NCSNavField
//
//  Created by John Dzak on 9/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Contact.h"
#import "Event.h"
#import "Person.h"
#import "NSString+Additions.h"
#import "NSDate+Additions.h"

@implementation Contact

@dynamic contactId, typeId, date, startTime, endTime, personId, person, initiated, events, locationId, locationOther, whoContactedId, whoContactedOther, comments, languageId, languageOther, interpreterId, interpreterOther, privateId, privateDetail, distanceTraveled, dispositionId, version;


- (BOOL) closed {
    return [self.dispositionId integerValue] != 0;
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

@end
