//
//  Instrument.h
//  NCSNavField
//
//  Created by John Dzak on 9/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Event;
@class InstrumentPlan;
@class ResponseSet;

FOUNDATION_EXPORT NSInteger const INSTRUMENT_TYPE_ID_PROVIDER_BASED_SAMPLING_SCRENER;

@interface Instrument : NSManagedObject 

@property(nonatomic,strong) NSString* instrumentId;

@property(nonatomic,strong) NSString* instrumentPlanId;

@property(nonatomic,strong) NSString* name;

@property(nonatomic,strong) NSNumber* instrumentTypeId;

@property(nonatomic,strong) NSString* instrumentTypeOther;

@property(nonatomic,strong) NSString* instrumentVersion;

@property(nonatomic,strong) NSNumber* repeatKey;

@property(nonatomic,strong) NSDate* startDate;

@property(nonatomic,strong) NSDate* startTime;

@property(nonatomic,strong) NSDate* endDate;

@property(nonatomic,strong) NSDate* endTime;

@property(nonatomic,strong) NSNumber* statusId;

@property(nonatomic,strong) NSNumber* breakOffId;

@property(nonatomic,strong) NSNumber* instrumentModeId;

@property(nonatomic,strong) NSString* instrumentModeOther;

@property(nonatomic,strong) NSNumber* instrumentMethodId;

@property(nonatomic,strong) NSNumber* supervisorReviewId;

@property(nonatomic,strong) NSNumber* dataProblemId;

@property(nonatomic,strong) NSString* comment;


/* Associations */

@property(nonatomic,strong) Event* event;

@property(nonatomic,strong) NSSet* responseSets;


#pragma setter

- (void) setResponseSetDicts:(NSDictionary *)responseSetDict;

- (void) setStartTimeJson:(NSString*)startTime;

- (void) setEndTimeJson:(NSString*)endTime;

#pragma getters

- (NSArray*) responseSetDicts;

- (NSString*) startTimeJson;

- (NSString*) endTimeJson;

- (InstrumentPlan*)instrumentPlan;

- (NSString*)determineInstrumentVersionFromSurveyTitle ;

- (NSString*)determineInstrumentVersion;

- (BOOL)isProviderBasedSamplingScreener;

@end

@interface Instrument (GeneratedAccessors)

- (void)addResponseSetsObject:(ResponseSet*)rs;

- (void)removeResponseSetsObject:(ResponseSet*)rs;

@end
