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
#import <NUSurveyor/UUID.h>

@implementation Contact

@dynamic contactId, typeId, date, startTime, endTime, personId, person, initiated, events, locationId, locationOther, whoContactedId, whoContactedOther, comments, languageId, languageOther, interpreterId, interpreterOther, privateId, privateDetail, distanceTraveled, dispositionId, version;

+ (Contact*)contact {
    Contact* c = [Contact object];
    c.contactId = [UUID generateUuidString];
    c.date = [NSDate date];
    c.startTime = [NSDate date];
    return c;
}

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

-(BOOL)onSameDay:(Contact*)c {
    
    NSDate *myDate,*yourDate;
    NSDateComponents *myComponents,*yourComponents;
    myDate = self.date;
    yourDate = c.date;
    //Check for nils
    if(!myDate || !yourDate) //If either is nil, then obviously they don't match. 
        return FALSE;
    NSCalendar *cal = [NSCalendar currentCalendar];
    myComponents = [cal components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:myDate];
    yourComponents = [cal components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:yourDate];
    if((myComponents.month == yourComponents.month)&&([myComponents year]==[yourComponents year])&&([myComponents day]==[yourComponents day]))
    {
        return TRUE;
    }
    return FALSE;
}


@end
