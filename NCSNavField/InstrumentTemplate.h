//
//  InstrumentTemplate.h
//  NCSNavField
//
//  Created by John Dzak on 11/14/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NUSurvey;

@interface InstrumentTemplate : NSManagedObject

@property(nonatomic,strong) NSString* instrumentTemplateId;
@property(nonatomic,strong) NSString* representation;
@property(nonatomic,strong) NSString* participantType;

- (void)setQuestionsAnswersAndRepresentationDictionary:(NSDictionary*)r;

- (NSDictionary*)representationDictionary;

- (NUSurvey*)survey;

@end
