//
//  SurveySeries.h
//  NCSNavField
//
//  Created by John Dzak on 10/1/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ResponseSet;
@class Participant;

@interface SurveySet : NSObject {
    NSArray* _surveys;
    NSArray* _responseSets;
    Participant* _participant;
}

@property(nonatomic,retain) NSArray* surveys;

@property(nonatomic,retain) NSArray* responseSets;

@property(nonatomic,retain) Participant* participant;

#pragma mark - Instance Methods

- (id)initWithSurveys:(NSArray*)s andResponseSets:(NSArray*)rs forParticipant:(Participant*)p;

- (ResponseSet*)generateResponseSetForSurveyId:(NSString*)surveyId;

- (ResponseSet*)populateResponseSet:(ResponseSet*)rs forSurveyId:sid;

@end
