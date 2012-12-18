//
//  ResponseTemplate.m
//  NCSNavField
//
//  Created by John Dzak on 12/13/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "ResponseTemplate.h"
#import "InstrumentTemplate.h"
#import <NUSurveyor/NUSurvey.h>
#import "NUSurvey+Additions.h"
#import "NUQuestion.h"
#import "NUAnswer.h"
#import "NSString+Additions.h"
#import <MRCEnumerable/MRCEnumerable.h>

@implementation ResponseTemplate

@dynamic qref, aref, value, surveyId;
@synthesize cachedSurvey, cachedQuestion, cachedAnswer;

- (NUSurvey*)survey {
    if (!self.cachedSurvey) {
        NSArray* templates = [InstrumentTemplate allObjects];
        self.cachedSurvey = [[[templates select:^BOOL(InstrumentTemplate* t){
            return [self.surveyId isEqualIgnoreCaseToString:[[t survey] uuid]];
        }] lastObject] survey];
    }
    return self.cachedSurvey;
}

- (NUQuestion*)question {
    if (!self.cachedQuestion) {
        if ([self survey]) {
            NSArray* questions = [[self survey] questionsForAllSections];
            for (NUQuestion* oth in questions) {
                if ([self.qref isEqualIgnoreCaseToString:[oth referenceIdentifier] ]) {
                    self.cachedQuestion = oth;
                    break;
                }
            }
        }
    }
    return self.cachedQuestion;
}

- (NUAnswer*) answer {
    if (!self.cachedAnswer) {
        if ([self question]) {
            for (NUAnswer* oth in [[self question] answers]) {
                if ([self.aref isEqualIgnoreCaseToString:[oth referenceIdentifier]]) {
                    self.cachedAnswer = oth;
                    break;
                }
            }
        }
    }
    return self.cachedAnswer;
}

@end
