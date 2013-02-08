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
@synthesize cachedInstrumentTemplate, cachedQuestion, cachedAnswer;

- (InstrumentTemplate*)instrumentTemplate {
    if (!self.cachedInstrumentTemplate) {
        NSArray* templates = [InstrumentTemplate allObjects];
        self.cachedInstrumentTemplate = [[templates select:^BOOL(InstrumentTemplate* t){
            return [self.surveyId isEqualIgnoreCaseToString:[[t survey] uuid]];
        }] lastObject];
    }
    return self.cachedInstrumentTemplate;
}

- (NUSurvey*)survey {
    return [[self instrumentTemplate] survey];
}

- (NUQuestion*)question {
    if (!self.cachedQuestion) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:
                                  @"(referenceIdentifier == %@) AND (instrumentTemplate == %@)",
                                  self.qref, [self instrumentTemplate]];
        self.cachedQuestion = [NUQuestion findFirstWithPredicate:predicate];
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
