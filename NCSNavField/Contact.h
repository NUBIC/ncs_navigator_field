//
//  Contact.h
//  NCSNavField
//
//  Created by John Dzak on 9/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Event;
@class Person;


@interface Contact : NSManagedObject

#pragma mark properties

@property(nonatomic,strong) NSString* contactId;

@property(nonatomic,strong) NSNumber* typeId;

@property(nonatomic,strong) NSDate* date;

@property(nonatomic,strong) NSDate* startTime;

@property(nonatomic,strong) NSDate* endTime;

@property(nonatomic,strong) NSString* personId;

@property(nonatomic) BOOL initiated;

@property(nonatomic,strong) NSNumber* locationId;

@property(nonatomic,strong) NSString* locationOther;

@property(nonatomic,strong) NSNumber* whoContactedId;

@property(nonatomic,strong) NSString* whoContactedOther;

@property(nonatomic,strong) NSString* comments;

@property(nonatomic,strong) NSNumber* languageId;

@property(nonatomic,strong) NSString* languageOther;

@property(nonatomic,strong) NSNumber* interpreterId;

@property(nonatomic,strong) NSString* interpreterOther;

@property(nonatomic,strong) NSNumber* privateId;

@property(nonatomic,strong) NSString* privateDetail;

@property(nonatomic,strong) NSNumber* distanceTraveled;

@property(nonatomic,strong) NSNumber* dispositionId;

@property(nonatomic,strong) NSString* version;


#pragma mark relations

@property(nonatomic,strong) NSSet* events;

@property(nonatomic,strong) Person* person;


#pragma mark methods

+ (Contact*)contact;

- (BOOL) closed;

#pragma setter

- (void) setStartTimeJson:(NSString*)startTime;

- (void) setEndTimeJson:(NSString*)endTime;

#pragma getters

- (NSString*) startTimeJson;

- (NSString*) endTimeJson;

@end

@interface Contact (GeneratedAccessors)

- (void)addEventsObject:(Event*)event;

- (void)removeEventsObject:(Event*)event;

@end
