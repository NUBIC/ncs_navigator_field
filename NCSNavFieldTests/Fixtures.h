//
//  Fixtures.h
//  NCSNavField
//
//  Created by John Dzak on 9/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Person;
@class Participant;
@class Event;
@class Contact;
@class Instrument;

@interface Fixtures : NSObject

+ (Participant*)createParticipantWithId:(NSString*)id person:(Person*)person;
+ (Person*) createPersonWithId:(NSString*)id name:(NSString*) n;
+ (NSDate*) createDateFromString:(NSString*) dateStr;
+ (NSDate*) createTimeFromString:(NSString*) timeStr;
+ (Event*) createEventWithName:(NSString*)name;
+ (Instrument*) createInstrumentWithName:(NSString*)name;
+ (Contact*) createContactWithDate:(NSDate*)date;
@end
