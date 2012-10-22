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
    NSArray* _prePopulatedQuestionRefs;
}

@property(nonatomic,strong) NSArray* surveys;

@property(nonatomic,strong) NSArray* responseSets;

@property(nonatomic,strong) NSArray* prePopulatedQuestionRefs;

#pragma mark - Instance Methods

- (id)initWithSurveys:(NSArray*)s andResponseSets:(NSArray*)rs;

- (ResponseSet*)generateResponseSetForSurveyId:(NSString*)sid participantId:(NSString*)pid;

- (ResponseSet*)populateResponseSet:(ResponseSet*)rs forSurveyId:sid forParticipant:(Participant*) pt;

- (NSDictionary*)sectionforSurveyIndex:(NSInteger)sui sectionIndex:(NSInteger)sei;

- (NSDictionary*)previousSectionfromSurveyIndex:(NSInteger)sui sectionIndex:(NSInteger)sei;

- (NSDictionary*)nextSectionfromSurveyIndex:(NSInteger)sui sectionIndex:(NSInteger)sei;

@end

#pragma mark - QuestionRef

@interface QuestionRef : NSObject {
    NSString* _attribute;
    NSString* _value;
}

@property(nonatomic,strong) NSString* attribute;

@property(nonatomic,strong) NSString* value;

- (id)initWithAttribute:(NSString*)attr value:(NSString*)value;

- (NSDictionary*)resolveInSurvey:(NUSurvey*)survey;

- (NSDictionary*)resolveInSurveys:(NSArray*)surveys;

@end

#pragma mark - AnswerRef

@interface AnswerRef : NSObject {
    NSString* _attribute;
    NSString* _value;
}

@property(nonatomic,strong) NSString* attribute;

@property(nonatomic,strong) NSString* value;

- (id)initWithAttribute:(NSString*)attr value:(NSString*)value;

- (NSDictionary*)resolveInSurvey:(NUSurvey*)survey;

- (NSDictionary*)resolveInSurveys:(NSArray*)surveys;

@end

#pragma mark - PrepopulatedQuestionRef

@interface PrePopulatedQuestionRefSet : NSObject {
    QuestionRef* _src;
    QuestionRef* _dest;
}

@property(nonatomic,strong) QuestionRef* src;

@property(nonatomic,strong) QuestionRef* dest;

- (id)initWithSource:(QuestionRef*)src destination:(QuestionRef*)dest;

@end

