//
//  SurveySeries.m
//  NCSNavField
//
//  Created by John Dzak on 10/1/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "SurveySet.h"
#import "ResponseSet.h"
#import "Participant.h"

@implementation SurveySet

@synthesize surveys = _surveys;
@synthesize responseSets = _responseSets;
@synthesize participant = _participant;

- (id)initWithSurveys:(NSArray*)s andResponseSets:(NSArray*)rs forParticipant:(Participant*)p {
    if (self = [self init]) {
        _surveys = [s retain];
        _responseSets = [rs retain];
        _participant = [p retain];
    }
    return self;
}

- (ResponseSet*)generateResponseSetForSurveyId:(NSString*)surveyId {
    ResponseSet* rs = [ResponseSet object];
    [rs setValue:self.participant.pId forKey:@"pId"];
    [rs setValue:surveyId forKey:@"survey"];
    return rs;
}

- (void)dealloc {
    [_surveys release];
    [_responseSets release];
    [_participant release];
    [super dealloc];
}

@end
