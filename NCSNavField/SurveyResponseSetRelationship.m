//
//  SurveyResponseSetRelationship.m
//  NCSNavField
//
//  Created by John Dzak on 12/14/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "SurveyResponseSetRelationship.h"
#import <NUSurveyor/NUSurvey.h>
#import "ResponseSet.h"

@implementation SurveyResponseSetRelationship

@synthesize survey = _survey;
@synthesize responseSet = _responseSet;

- (id)initWithSurvey:(NUSurvey*)survey responseSet:(ResponseSet*)responseSet {
    self = [self init];
    if (self) {
        self.survey = survey;
        self.responseSet = responseSet;
    }
    return self;
}

@end
