//
//  Instrument.h
//  NCSNavField
//
//  Created by John Dzak on 9/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class InstrumentTemplate;
@class Event;
@class ResponseSet;

@interface Instrument : NSManagedObject 

@property(nonatomic,retain) NSString* instrumentId;

@property(nonatomic,retain) NSString* name;

@property(nonatomic,retain) NSString* instrumentTemplateId;

@property(nonatomic,retain) NSNumber* instrumentTypeId;

@property(nonatomic,retain) NSString* instrumentTypeOther;

@property(nonatomic,retain) NSString* instrumentVersion;

@property(nonatomic,retain) NSNumber* repeatKey;

@property(nonatomic,retain) NSDate* startDate;

@property(nonatomic,retain) NSDate* startTime;

@property(nonatomic,retain) NSDate* endDate;

@property(nonatomic,retain) NSDate* endTime;

@property(nonatomic,retain) NSNumber* statusId;

@property(nonatomic,retain) NSNumber* breakOffId;

@property(nonatomic,retain) NSNumber* instrumentModeId;

@property(nonatomic,retain) NSString* instrumentModeOther;

@property(nonatomic,retain) NSNumber* instrumentMethodId;

@property(nonatomic,retain) NSNumber* supervisorReviewId;

@property(nonatomic,retain) NSNumber* dataProblemId;

@property(nonatomic,retain) NSString* comment;


/* Associations */

@property(nonatomic,retain) Event* event;

@property(nonatomic,retain) InstrumentTemplate* instrumentTemplate;

@property(nonatomic,retain) NSSet* responseSets;


#pragma setter

- (void) setResponseSetDicts:(NSDictionary *)responseSetDict;

- (void) setStartTimeJson:(NSString*)startTime;

- (void) setEndTimeJson:(NSString*)endTime;

#pragma getters

- (NSArray*) responseSetDicts;

- (NSString*) startTimeJson;

- (NSString*) endTimeJson;

@end
