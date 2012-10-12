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
#import "Instrument.h"
#import "CoreData.h"

@implementation Fixtures

+ (Person*) createPersonWithId:(NSString*)id name:(NSString*) n {
    Person *p = [Person object];
    p.name = n;
    return p;
}


+ (NSDate*) createDateFromString:(NSString*) dateStr {
    NSDateFormatter* f = [[NSDateFormatter alloc] init];
    [f setDateFormat:@"yyyy'-'MM'-'dd'"];
    [f setTimeZone:[NSTimeZone localTimeZone]];
    
    NSDate* d = [f dateFromString:dateStr];

    
    return d;
}

+ (NSDate*) createTimeFromString:(NSString*) timeStr {
    NSDateFormatter* f = [[NSDateFormatter alloc] init];
    [f setDateFormat:@"HH':'mm"];
    [f setTimeZone:[NSTimeZone localTimeZone]];
    
    NSDate* d = [f dateFromString:timeStr];
    
    
    return d;
}

+ (Event*) createEventWithName:(NSString*)name {
    Event *e = [Event object];
    e.name = name;
    return e;
}


+ (Instrument*) createInstrumentWithName:(NSString*)name {
    Instrument *i = [Instrument object];
    i.name = name;
    return i;
}

+ (Contact*) createContactWithDate:(NSDate*)date {
    Contact *c = [Contact object];
    c.date = date;
    return c;
}

@end
