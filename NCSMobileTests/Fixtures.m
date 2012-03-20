//
//  Fixtures.m
//  NCSMobile
//
//  Created by John Dzak on 9/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Fixtures.h"
#import "Person.h"
#import "Event.h"
#import "Contact.h"

@implementation Fixtures

+ (Person*) createPersonWithId:(NSString*)id name:(NSString*) n {
    Person *p = [[Person alloc] init];
    p.name = n;
    return [p autorelease];
}


+ (NSDate*) createDateFromString:(NSString*) dateStr {
    NSDateFormatter* f = [[NSDateFormatter alloc] init];
    [f setDateFormat:@"yyyy'-'MM'-'dd' 'HH':'mm"];
    [f setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    NSDate* d = [f dateFromString:dateStr];

    [f dealloc];
    
    return d;
}

+ (Event*) createEventWithName:(NSString*)name date:(NSDate*)date {
    Event *e = [[Event alloc] init];
    e.name = name;
    return [e autorelease];
}

+ (Event*) createEventWithName:(NSString*)name date:(NSDate*)date person:(Person*)person {
    Event *e = [self createEventWithName:name date:date];
    return [e autorelease];
}

+ (Contact*) createContactWithName:(NSString*)name startDate:(NSDate*)date person:(Person*)person {
    Contact *c = [[Contact alloc] init];
    c.startDate = date;
    c.person = person;
//    Event *e = [self createEventWithName:name date:date person:person];
    return [c autorelease];
}




@end
