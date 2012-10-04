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
static ResponseSet* responseSetA;
static ResponseSet* responseSetB;
static SurveySet* surveySet;
static NUSurvey* surveyA;
static NUSurvey* surveyB;

- (void)setUp {
    participant = [self createParticipant:@"yak423"];

    surveyA = [[NUSurvey new] autorelease];
    surveyA.jsonString =
        @"{"
         "  \"uuid\":\"survey-a\","
         "  \"sections\":[{"
         "    \"questions_and_groups\":["
         "      { "
         "        \"uuid\":\"q1\","
         "        \"data_export_identifier\":\"bar\","
         "        \"answers\":["
         "          {\"uuid\":\"a1\", \"type\":\"string\"}"
         "        ]"
         "      }"
         "    ]"
         "  }]"
         "}";
    
    surveyB = [[NUSurvey new] autorelease];
    surveyB.jsonString =
        @"{"
        "  \"uuid\":\"survey-b\","
        "  \"sections\":[{"
        "    \"questions_and_groups\":["
        "      { "
        "        \"uuid\":\"q2\","
        "        \"reference_identifier\":\"pre_populated_foo\","
        "        \"answers\":["
        "          {\"uuid\":\"a2\", \"type\":\"hidden\"}"
        "        ]"
        "      }"
        "    ]"
        "  }]"
        "}";
    
    responseSetA = [self createResponseSetWithSurveyId:@"survey-a" participantId:participant.pId];
    [responseSetA newResponseForQuestion:@"q1" Answer:@"a1" Value:@"woot"];
    
    participant = [self createParticipant:@"yak423"];
    responseSetB = [self createResponseSetWithSurveyId:@"survey-b" participantId:participant.pId];
    
    surveySet = [[[SurveySet alloc] initWithSurveys:[NSArray arrayWithObjects:surveyA,surveyB,nil] andResponseSets:[NSArray arrayWithObject:responseSetA] forParticipant:participant] autorelease];
}

#pragma mark - SurveySet#generateResponseSet

- (void)testEmptyResponseSetGenerated {
    SurveySet* ss = [[[SurveySet alloc] initWithSurveys:[NSArray array] andResponseSets:[NSArray array] forParticipant:participant] autorelease];
    
    ResponseSet* act = [ss generateResponseSetForSurveyId:@"survey-z"];
    
    STAssertEqualObjects([act valueForKey:@"survey"], @"survey-z", @"Wrong survey id");
    STAssertEqualObjects([act valueForKey:@"pId"], @"yak423", @"Wrong pId");
    STAssertTrue([[act responses] count] == 0, @"Should be empty");
}

#pragma mark - SurveySet#populateResponseSet

- (void)testPopulateResponseSet {
    ResponseSet* act = [surveySet populateResponseSet:responseSetB forSurveyId:@"survey-b"];
    STAssertEqualObjects([act valueForKey:@"survey"], @"survey-b", @"Wrong survey id");
    STAssertEqualObjects([act valueForKey:@"pId"], @"yak423", @"Wrong pId");
    STAssertEquals((int)[[act responses] count], 1, @"Should be 1");
    NUResponse* r = [[[act responses] objectEnumerator] nextObject];
    STAssertEqualObjects([r valueForKey:@"question"], @"q2", @"Wrong question");
    STAssertEqualObjects([r valueForKey:@"answer"], @"a2", @"Wrong answer");
    STAssertEqualObjects([r valueForKey:@"value"], @"woot", @"Wrong response value");
}

- (void)testPopulateResponseSetWithDifferentResponseValue {
    [responseSetB newResponseForQuestion:@"q2" Answer:@"a2" Value:@"lok"];
    ResponseSet* act = [surveySet populateResponseSet:responseSetB forSurveyId:@"survey-b"];
    STAssertEqualObjects([act valueForKey:@"survey"], @"survey-b", @"Wrong survey id");
    STAssertEqualObjects([act valueForKey:@"pId"], @"yak423", @"Wrong pId");
    STAssertEquals((int)[[act responses] count], 1, @"Should be 1");
    NUResponse* r = [[[act responses] objectEnumerator] nextObject];
    STAssertEqualObjects([r valueForKey:@"value"], @"woot", @"Wrong response value");
}

- (void)testPopulateResponseSetWithoutPrepopulatedQuestions {
    NUSurvey* noPrePop = [NUSurvey new];
    noPrePop.jsonString = @"{\"uuid\":\"survey-d\"}";
    ResponseSet* rsNoPrePop = [self createResponseSetWithSurveyId:@"survey-d" participantId:participant.pId];
    SurveySet* ss = [[[SurveySet alloc] initWithSurveys:[NSArray arrayWithObject:noPrePop] andResponseSets:[NSArray arrayWithObject:rsNoPrePop] forParticipant:participant] autorelease];
    ResponseSet* act = [ss populateResponseSet:rsNoPrePop forSurveyId:@"survey-d"];
    STAssertEqualObjects([act valueForKey:@"survey"], @"survey-d", @"Wrong survey id");
    STAssertEqualObjects([act valueForKey:@"pId"], @"yak423", @"Wrong pId");
    STAssertTrue([[act responses] count] == 0, @"Should be empty");
}

- (void)testPopulateResponseSetWithIncorrectPid {
    
}

- (void)testPopulateResponseSetWithIncorrectSurveyId {
    
}

#pragma mark - SurveySet#questionDictByAttribute

- (void)testQuestionDictByAttribute {
//    NSDictionary* act = [surveySet questionDictByRefIdForSurvey:surveyB];
//    STAssertEquals((int) [act count], 1, @"Wrong number of questions");
//    STAssertEqualObjects([[[act allKeys] objectEnumerator] nextObject], @"pre_populated_foo", @"Wrong reference identifier");
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
