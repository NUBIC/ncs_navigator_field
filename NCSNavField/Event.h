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

@property(nonatomic,strong) NSNumber* eventTypeCode;

@property(nonatomic,strong) NSString* eventTypeOther;

@property(nonatomic,strong) NSNumber* eventRepeatKey;

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

@interface Event (CoreDataGeneratedAccessors)

- (void)insertObject:(Instrument *)value inInstrumentsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromInstrumentsAtIndex:(NSUInteger)idx;
- (void)insertInstruments:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeInstrumentsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInInstrumentsAtIndex:(NSUInteger)idx withObject:(Instrument *)alue;
- (void)replaceInstrumentsAtIndexes:(NSIndexSet *)indexes withInstruments:(NSArray *)alues;
- (void)addInstrumentsObject:(Instrument *)value;
- (void)removeInstrumentsObject:(Instrument *)value;
- (void)addInstruments:(NSOrderedSet *)values;
- (void)removeInstruments:(NSOrderedSet *)values;
@end

