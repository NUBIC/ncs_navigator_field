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
#import <MRCEnumerable/MRCEnumerable.h>

@implementation ResponseTemplate

@dynamic qref;
@dynamic aref;
@dynamic value;
@dynamic surveyId;

- (NUSurvey*)survey {
    NSArray* templates = [InstrumentTemplate allObjects];
    return [[templates select:^BOOL(id obj){
        InstrumentTemplate* t = obj;
        return [self.surveyId isEqualToString:[[t survey] uuid]];
    }] lastObject];
}

@end
