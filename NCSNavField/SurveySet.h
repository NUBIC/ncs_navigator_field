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
@class NUSurvey;

@interface SurveySet : NSObject {
    NSArray* _surveys;
    NSArray* _responseSets;
    Participant* _participant;
    NSArray* _prePopulatedQuestionRefs;
}

@property(nonatomic,retain) NSArray* surveys;

@property(nonatomic,retain) NSArray* responseSets;

@property(nonatomic,retain) Participant* participant;

@property(nonatomic,retain) NSArray* prePopulatedQuestionRefs;

#pragma mark - Instance Methods

- (id)initWithSurveys:(NSArray*)s andResponseSets:(NSArray*)rs forParticipant:(Participant*)p;

- (ResponseSet*)generateResponseSetForSurveyId:(NSString*)surveyId;

- (ResponseSet*)populateResponseSet:(ResponseSet*)rs forSurveyId:sid;

@end

#pragma mark - QuestionRef

@interface QuestionRef : NSObject {
    NSString* _attribute;
    NSString* _value;
}

@property(nonatomic,retain) NSString* attribute;

@property(nonatomic,retain) NSString* value;

- (id)initWithAttribute:(NSString*)attr value:(NSString*)value;

- (NSDictionary*)resolveInSurvey:(NUSurvey*)survey;

- (NSDictionary*)resolveInSurveys:(NSArray*)surveys;

@end

#pragma mark - PrepopulatedQuestionRef

@interface PrePopulatedQuestionRefSet : NSObject {
    QuestionRef* _src;
    QuestionRef* _dest;
}

@property(nonatomic,retain) QuestionRef* src;

@property(nonatomic,retain) QuestionRef* dest;

- (id)initWithSource:(QuestionRef*)src destination:(QuestionRef*)dest;

@end

