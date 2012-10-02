//
//  SurveySetTest.m
//  NCSNavField
//
//  Created by John Dzak on 10/1/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "SurveySetTest.h"
#import "SurveySet.h"
#import "ResponseSet.h"
#import "Participant.h"
#import <NUSurveyor/NUSurvey.h>

@implementation SurveySetTest

static Participant* participant;
static ResponseSet* responseSet;
static SurveySet* surveySet;

- (void)setUp {
    participant = [self createParticipant:@"yak423"];
    responseSet = [self createResponseSetWithSurveyId:@"survey-a" participantId:participant.pId];
    [responseSet newResponseForQuestion:@"que-a" Answer:@"ans-a" Value:@"bar"];
    
    NUSurvey* survey = [[NUSurvey new] autorelease];
    survey.jsonString =
        @"{"
         "  \"uuid\":\"survey-a\","
         "  \"sections\":[{"
         "    \"questions_and_groups\":["
         "      { \"uuid\":\"q1\", \"reference_identifier\":\"foo\"}"
         "    ]"
         "  }]"
         "}";
    
    surveySet = [[[SurveySet alloc] initWithSurveys:[NSArray arrayWithObject:survey] andResponseSets:[NSArray arrayWithObject:responseSet] forParticipant:participant] autorelease];
}

#pragma mark - SurveySet#generateResponseSet

- (void)testEmptyResponseSetGenerated {
    SurveySet* ss = [[[SurveySet alloc] initWithSurveys:[NSArray array] andResponseSets:[NSArray array] forParticipant:participant] autorelease];
    
    ResponseSet* a = [ss generateResponseSetForSurveyId:@"survey-z"];
    
    STAssertEqualObjects([a valueForKey:@"survey"], @"survey-z", @"Wrong survey id");
    STAssertEqualObjects([a valueForKey:@"pId"], @"yak423", @"Wrong pId");
    STAssertFalse([[a responses] count] > 0, @"Should be empty");
}

#pragma mark - SurveySet#populateResponseSet

- (void)testPopulateResponseSet {
    ResponseSet* a = [surveySet populateResponseSet:responseSet forSurveyId:@"survey-a"];
    STAssertEqualObjects([a valueForKey:@"survey"], @"survey-a", @"Wrong survey id");
    STAssertEqualObjects([a valueForKey:@"pId"], @"yak423", @"Wrong pId");
    STAssertEquals((int)[[a responses] count], 1, @"Should be 1");
    NUResponse* r = [[[a responses] objectEnumerator] nextObject];
    STAssertEqualObjects([r valueForKey:@"value"], @"bar", @"Wrong response value");
}

- (void)testPopulateResponseSetWithDifferentResponseValue {
    responseSet.responses = [NSMutableSet new];
    [responseSet newResponseForQuestion:@"que-a" Answer:@"ans-a" Value:@"lok"];
    ResponseSet* a = [surveySet populateResponseSet:responseSet forSurveyId:@"survey-a"];
    STAssertEqualObjects([a valueForKey:@"survey"], @"survey-a", @"Wrong survey id");
    STAssertEqualObjects([a valueForKey:@"pId"], @"yak423", @"Wrong pId");
    STAssertEquals((int)[[a responses] count], 1, @"Should be 1");
    NUResponse* r = [[[a responses] objectEnumerator] nextObject];
    STAssertEqualObjects([r valueForKey:@"value"], @"lok", @"Wrong response value");
}

- (void)testPopulateResponseSetWithoutPrepopulatedQuestions {
    NUSurvey* s = [NUSurvey new];
    s.jsonString = @"{\"uuid\":\"survey-d\"}";
    ResponseSet* rs = [self createResponseSetWithSurveyId:@"survey-d" participantId:participant.pId];
    SurveySet* ss = [[[SurveySet alloc] initWithSurveys:[NSArray arrayWithObject:s] andResponseSets:[NSArray arrayWithObject:rs] forParticipant:participant] autorelease];
    ResponseSet* a = [ss populateResponseSet:rs forSurveyId:@"survey-d"];
    STAssertEqualObjects([a valueForKey:@"survey"], @"survey-d", @"Wrong survey id");
    STAssertEqualObjects([a valueForKey:@"pId"], @"yak423", @"Wrong pId");
    STAssertFalse([[a responses] count] > 0, @"Should be empty");
}

- (void)testPopulateResponseSetWithIncorrectPid {
    
}

- (void)testPopulateResponseSetWithIncorrectSurveyId {
    
}

#pragma mark - Helper Methods

- (Participant*)createParticipant:(NSString*)participantId {
    Participant *p = [Participant object];
    p.pId = participantId;
    return p;
}

- (ResponseSet*)createResponseSetWithSurveyId:(NSString*)sid participantId:(NSString*)pid {
    ResponseSet* rs = [ResponseSet object];
    [rs setValue:sid forKey:@"survey"];
    [rs setValue:pid forKey:@"pId"];
    return rs;
}

@end
