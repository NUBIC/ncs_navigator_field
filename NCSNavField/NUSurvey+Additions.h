//
//  NUSurvey+Additions.h
//  NCSNavField
//
//  Created by John Dzak on 9/19/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "NUSurvey.h"

@class InstrumentTemplate;

@interface NUSurvey (Additions)

- (NSString*)title;

- (NSString*)uuid;

- (NSDictionary*)deserialized;

- (NSArray*)sections;

- (NSArray*)questionsForAllSections;

- (InstrumentTemplate*)instrumentTemplate;

+ (NUSurvey*)findByUUUID:(NSString*)uuid;

@end
