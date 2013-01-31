//
//  InstrumentTemplate.m
//  NCSNavField
//
//  Created by John Dzak on 11/14/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "InstrumentTemplate.h"
#import <NUSurveyor/NUSurvey.h>
#import "NUSurvey+Additions.h"
#import <JSONKit/JSONKit.h>
#import <MRCEnumerable/MRCEnumerable.h>
#import "NUQuestion.h"

@implementation InstrumentTemplate
@dynamic instrumentTemplateId,representation,participantType;

- (void)setQuestionsAnswersAndRepresentationDictionary:(NSDictionary*)r {
    self.representation = [r JSONString];
    
    NSArray* questions = [self.survey questionsForAllSections];
    [questions each:^(NUQuestion* q){ [q persist];}];
}

- (NSDictionary*)representationDictionary {
    return [self.representation objectFromJSONString];
}

- (NUSurvey*)survey {
    NUSurvey* s = [NUSurvey new];
    s.jsonString = self.representation;
    return s;
}

@end
