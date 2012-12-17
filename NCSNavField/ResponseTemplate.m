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

@dynamic qref;
@dynamic aref;
@dynamic value;
@dynamic surveyId;

- (NUSurvey*)survey {
    NSArray* templates = [InstrumentTemplate allObjects];
    return [[[templates select:^BOOL(id obj){
        InstrumentTemplate* t = obj;
        return [self.surveyId isEqualIgnoreCaseToString:[[t survey] uuid]];
    }] lastObject] survey];
}

- (NUQuestion*)question {
    NUQuestion* found = nil;
    if ([self survey]) {
        NSArray* questions = [[self survey] questionsForAllSections];
        for (NUQuestion* oth in questions) {
            if ([self.qref isEqualIgnoreCaseToString:[oth referenceIdentifier] ]) {
                found = oth;
                break;
            }
        }
    }
    return found;
}

- (NUAnswer*) answer {
    NUAnswer* found = nil;
    if ([self question]) {
        for (NUAnswer* oth in [[self question] answers]) {
            if ([self.aref isEqualIgnoreCaseToString:[oth referenceIdentifier]]) {
                found = oth;
                break;
            }
        }
    }
    return found;
}

@end
