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
@dynamic instrumentTemplateId,representation,participantType, questions;

- (void)setRepresentationDictionary:(NSDictionary*)dict {
    self.representation = [dict JSONString];
}

- (NSDictionary*)representationDictionary {
    return [self.representation objectFromJSONString];
}

- (NUSurvey*)survey {
    NUSurvey* s = [NUSurvey new];
    s.jsonString = self.representation;
    return s;
}

- (void)refreshQuestions {
    if (self.survey) {
        [self deleteAllQuestions];
        NSArray* questions = [self.survey questionsForAllSections];
        [questions each:^(NUQuestion* q){ [q persist];}];
    }
}

- (void)deleteAllQuestions {
    for (NUQuestion* question in self.questions) {
        [question deleteEntity];
    }
}

@end
