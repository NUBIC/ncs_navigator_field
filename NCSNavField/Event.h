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

@property(nonatomic,strong) NSString* eventId;

@property(nonatomic,strong) NSString* name;

@property(nonatomic,strong) NSNumber* eventTypeId;

@property(nonatomic,strong) NSString* eventTypeOther;

@property(nonatomic,strong) NSNumber* repeatKey;

@property(nonatomic,strong) NSDate* startDate;

@property(nonatomic,strong) NSDate* endDate;

@property(nonatomic,strong) NSDate* startTime;

@property(nonatomic,strong) NSDate* endTime;

@property(nonatomic,strong) NSNumber* incentiveTypeId;

@property(nonatomic,strong) NSString* incentiveCash;

@property(nonatomic,strong) NSString* incentiveNonCash;

@property(nonatomic,strong) NSNumber* dispositionId;

@property(nonatomic,strong) NSNumber* dispositionCategoryId;

@property(nonatomic,strong) NSNumber* breakOffId;

@property(nonatomic,strong) NSString* comments;

@property(nonatomic,strong) NSString* version;

/* relationships */

@property(nonatomic,strong) Contact* contact;

@property(nonatomic,strong) NSSet* instruments;

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

