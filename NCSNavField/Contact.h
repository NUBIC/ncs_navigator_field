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

@property(nonatomic,retain) NSString* contactId;

@property(nonatomic,retain) NSNumber* typeId;

@property(nonatomic,retain) NSDate* date;

@property(nonatomic,retain) NSDate* startTime;

@property(nonatomic,retain) NSDate* endTime;

@property(nonatomic,retain) NSString* personId;

@property(nonatomic) BOOL initiated;

@property(nonatomic,retain) NSNumber* locationId;

@property(nonatomic,retain) NSString* locationOther;

@property(nonatomic,retain) NSNumber* whoContactedId;

@property(nonatomic,retain) NSString* whoContactedOther;

@property(nonatomic,retain) NSString* comments;

@property(nonatomic,retain) NSNumber* languageId;

@property(nonatomic,retain) NSString* languageOther;

@property(nonatomic,retain) NSNumber* interpreterId;

@property(nonatomic,retain) NSString* interpreterOther;

@property(nonatomic,retain) NSNumber* privateId;

@property(nonatomic,retain) NSString* privateDetail;

@property(nonatomic,retain) NSString* distanceTraveled;

@property(nonatomic,retain) NSNumber* dispositionId;

@property(nonatomic,retain) NSString* version;


#pragma mark relations

@property(nonatomic,retain) NSSet* events;

@property(nonatomic,retain) Person* person;


#pragma mark methods

- (BOOL) closed;

@end
