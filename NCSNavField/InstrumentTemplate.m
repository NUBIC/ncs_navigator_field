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
    [self refreshQuestionsFromSurvey];
}

- (NSDictionary*)representationDictionary {
    return [self.representation objectFromJSONString];
}

- (NUSurvey*)survey {
    NUSurvey* s = [NUSurvey new];
    s.jsonString = self.representation;
    return s;
}

- (void)refreshQuestionsFromSurvey {
    if (self.survey) {
        [self deleteAllQuestions];
        NSArray* questions = [self.survey questionsForAllSections];
        [questions each:^(NUQuestion* q){
            NUQuestion* persisted = [q persist];
            [self addQuestionsObject:persisted];
        }];
    }
    [[NSManagedObjectContext contextForCurrentThread] save:nil];
}

- (void)deleteAllQuestions {
    for (NUQuestion* question in self.questions) {
        [question deleteEntity];
    }
}

// BUG: This is a workaround for a bug when using the generated method
//      addInstrumentsObject to add an instrument to the ordered set.
//      https://openradar.appspot.com/10114310
- (void)addQuestionsObject:(NUQuestion *)value {
    NSMutableOrderedSet *temporaryInstruments = [self.questions mutableCopy];
    [temporaryInstruments addObject:value];
    self.questions = [NSOrderedSet orderedSetWithOrderedSet:temporaryInstruments];
}

@end
