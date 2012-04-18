//
//  Fixtures.m
//  NCSNavField
//
//  Created by John Dzak on 9/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Fixtures.h"
#import "Person.h"
#import "Event.h"
#import "Contact.h"
#import "RestKit.h"
#import "CoreData.h"

@implementation Fixtures

+ (Person*) createPersonWithId:(NSString*)id name:(NSString*) n {
    Person *p = [Person object];
    p.name = n;
    return [p autorelease];
}


+ (NSDate*) createDateFromString:(NSString*) dateStr {
    NSDateFormatter* f = [[NSDateFormatter alloc] init];
    [f setDateFormat:@"yyyy'-'MM'-'dd' 'HH':'mm"];
    [f setTimeZone:[NSTimeZone localTimeZone]];
    
    NSDate* d = [f dateFromString:dateStr];

    [f dealloc];
    
    return d;
}

+ (NSDate*) createTimeFromString:(NSString*) timeStr {
    NSDateFormatter* f = [[NSDateFormatter alloc] init];
    [f setDateFormat:@"HH':'mm"];
    [f setTimeZone:[NSTimeZone localTimeZone]];
    
    NSDate* d = [f dateFromString:timeStr];
    
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

+ (Contact*) createContactWithName:(NSString*)name startDate:(NSDate*)date {
    Contact *c = [Contact object];
    c.date = date;
    return [c autorelease];
}




@end
