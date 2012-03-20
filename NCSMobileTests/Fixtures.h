//
//  Fixtures.h
//  NCSMobile
//
//  Created by John Dzak on 9/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Person;
@class Event;
@class Contact;

@interface Fixtures : NSObject

+ (Person*) createPersonWithId:(NSString*)id name:(NSString*) n;
+ (NSDate*) createDateFromString:(NSString*) dateStr;
+ (Event*) createEventWithName:(NSString*)name date:(NSDate*)date;
+ (Event*) createEventWithName:(NSString*)name date:(NSDate*)date person:(Person*)person;
+ (Contact*) createContactWithName:(NSString*)name startDate:(NSDate*)date person:(Person*)person;
@end
