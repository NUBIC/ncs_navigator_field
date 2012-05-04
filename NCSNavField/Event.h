//
//  Event.h
//  NCSNavField
//
//  Created by John Dzak on 9/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Contact;
@class Instrument;

@interface Event : NSManagedObject

/* properties */

@property(nonatomic,retain) NSString* eventId;

@property(nonatomic,retain) NSString* name;

@property(nonatomic,retain) NSNumber* eventTypeId;

@property(nonatomic,retain) NSString* eventTypeOther;

@property(nonatomic,retain) NSString* repeatKey;

@property(nonatomic,retain) NSDate* startDate;

@property(nonatomic,retain) NSDate* endDate;

@property(nonatomic,retain) NSDate* startTime;

@property(nonatomic,retain) NSDate* endTime;

@property(nonatomic,retain) NSNumber* incentiveTypeId;

@property(nonatomic,retain) NSString* incentiveCash;

@property(nonatomic,retain) NSString* incentiveNonCash;

@property(nonatomic,retain) NSNumber* dispositionId;

@property(nonatomic,retain) NSNumber* dispositionCategoryId;

@property(nonatomic,retain) NSNumber* breakOffId;

@property(nonatomic,retain) NSString* comments;

@property(nonatomic,retain) NSString* version;

/* relationships */

@property(nonatomic,retain) Contact* contact;

@property(nonatomic,retain) NSSet* instruments;

#pragma setter

- (void) setStartTimeJson:(NSString*)startTime;

- (void) setEndTimeJson:(NSString*)endTime;

#pragma getters

- (NSString*) startTimeJson;

- (NSString*) endTimeJson;

@end

@interface Event (GeneratedAccessors)

- (void)addInstrumentsObject:(Instrument*)instrument;

- (void)removeInstrumentsObject:(Instrument*)instrument;

@end

