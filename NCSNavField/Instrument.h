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
@class NUResponseSet;

@interface Instrument : NSManagedObject 

@property(nonatomic,retain) NSString* instrumentId;

@property(nonatomic,retain) NSString* name;

@property(nonatomic,retain) NSString* instrumentTemplateId;

@property(nonatomic,retain) InstrumentTemplate* instrumentTemplate;

@property(nonatomic,retain) NSString* externalResponseSetId;

@property(nonatomic,retain) NSNumber* instrumentTypeId;

@property(nonatomic,retain) NSString* instrumentTypeOther;

@property(nonatomic,retain) NSString* instrumentVersion;

@property(nonatomic,retain) NSString* repeatKey;

@property(nonatomic,retain) NSDate* startDate;

@property(nonatomic,retain) NSString* startTime;

@property(nonatomic,retain) NSDate* endDate;

@property(nonatomic,retain) NSNumber* status;

@property(nonatomic,retain) NSInteger* breakoff;

@property(nonatomic,retain) NSInteger* instrumentModeId;

@property(nonatomic,retain) NSString* instrumentModeOther;

@property(nonatomic,retain) NSInteger* instrumentMethodId;

@property(nonatomic,retain) NSInteger* supervisorReviewId;

@property(nonatomic,retain) NSInteger* dataProblem;

@property(nonatomic,retain) NSString* comment;


/* Associations */

@property(nonatomic,retain) Event* event;


- (NUResponseSet*) responseSet;

- (NSDictionary*) responseSetDict;

- (void)setResponseSet:(NUResponseSet *)responseSet;

- (void) setResponseSetDict:(NSDictionary *)responseSetDict;

@end
