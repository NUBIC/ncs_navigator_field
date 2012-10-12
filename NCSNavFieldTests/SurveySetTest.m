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
#import <NUSurveyor/NUResponse.h>

@implementation SurveySetTest

static Participant* participant;
static ResponseSet* responseSetA;
static ResponseSet* responseSetB;
static SurveySet* surveySet;
static NUSurvey* surveyA;
static NUSurvey* surveyB;

- (void)setUp {
    participant = [self createParticipant:@"yak423"];

    surveyA = [NUSurvey new];
    surveyA.jsonString =
        @"{"
         "  \"uuid\":\"survey-a\","
         "  \"sections\":[{"
         "    \"questions_and_groups\":["
         "      { "
         "        \"uuid\":\"q1\","
         "        \"data_export_identifier\":\"name\","
         "        \"answers\":["
         "          {\"uuid\":\"a1\", \"type\":\"string\"}"
         "        ]"
         "      },"
         "      { "
         "        \"uuid\":\"q2\","
         "        \"data_export_identifier\":\"color\","
         "        \"answers\":["
         "          {\"uuid\":\"a2\", \"reference_identifier\":\"red\"},"
         "          {\"uuid\":\"a3\", \"reference_identifier\":\"blue\"}"
         "        ]"
         "      }"
         "    ]"
         "  }]"
         "}";
    
    surveyB = [NUSurvey new];
    surveyB.jsonString =
        @"{"
         "  \"uuid\":\"survey-b\","
         "  \"sections\":[{"
         "    \"questions_and_groups\":["
         "      { "
         "        \"uuid\":\"q10\","
         "        \"reference_identifier\":\"pre_populated_name\","
         "        \"answers\":["
         "          {\"uuid\":\"a10\", \"type\":\"hidden\"}"
         "        ]"
         "      },"
         "      { "
         "        \"uuid\":\"q11\","
         "        \"reference_identifier\":\"pre_populated_color\","
         "        \"answers\":["
         "          {\"uuid\":\"a11\", \"reference_identifier\":\"red\"},"
         "          {\"uuid\":\"a12\", \"reference_identifier\":\"blue\"}"
         "        ]"
         "      }"
         "    ]"
         "  }]"
         "}";
    
    responseSetA = [self createResponseSetWithSurveyId:@"survey-a" participantId:participant.pId];
    [responseSetA newResponseForQuestion:@"q1" Answer:@"a1" Value:@"woot"];
    
    participant = [self createParticipant:@"yak423"];
    responseSetB = [self createResponseSetWithSurveyId:@"survey-b" participantId:participant.pId];
    
    surveySet = [[SurveySet alloc] initWithSurveys:[NSArray arrayWithObjects:surveyA,surveyB,nil] andResponseSets:[NSArray arrayWithObject:responseSetA] forParticipant:participant];

    surveySet.prePopulatedQuestionRefs = [NSArray arrayWithObjects:
                                          [self destRefId:@"pre_populated_name" srcDataExpId:@"name"],
                                          [self destRefId:@"pre_populated_color" srcDataExpId:@"color"], nil];
}

#pragma mark - SurveySet#generateResponseSet

- (void)testEmptyResponseSetGenerated {
    SurveySet* ss = [[SurveySet alloc] initWithSurveys:[NSArray array] andResponseSets:[NSArray array] forParticipant:participant];
    
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
    STAssertEqualObjects([r valueForKey:@"question"], @"q10", @"Wrong question");
    STAssertEqualObjects([r valueForKey:@"answer"], @"a10", @"Wrong answer");
    STAssertEqualObjects([r valueForKey:@"value"], @"woot", @"Wrong response value");
}

- (void)testPopulateResponseSetWithDifferentResponseValue {
    [responseSetB newResponseForQuestion:@"q10" Answer:@"a10" Value:@"lok"];
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
    SurveySet* ss = [[SurveySet alloc] initWithSurveys:[NSArray arrayWithObject:noPrePop] andResponseSets:[NSArray arrayWithObject:rsNoPrePop] forParticipant:participant];
    ResponseSet* act = [ss populateResponseSet:rsNoPrePop forSurveyId:@"survey-d"];
    STAssertEqualObjects([act valueForKey:@"survey"], @"survey-d", @"Wrong survey id");
    STAssertEqualObjects([act valueForKey:@"pId"], @"yak423", @"Wrong pId");
    STAssertTrue([[act responses] count] == 0, @"Should be empty");
}

- (void)testPopulateResponseSetWithNullResponseSet {
    ResponseSet* act = [surveySet populateResponseSet:nil forSurveyId:@"survey-b"];
    STAssertEqualObjects([act valueForKey:@"survey"], @"survey-b", @"Wrong survey id");
    STAssertEqualObjects([act valueForKey:@"pId"], @"yak423", @"Wrong pId");
    STAssertEquals((int)[[act responses] count], 1, @"Should be 1");
    NUResponse* r = [[[act responses] objectEnumerator] nextObject];
    STAssertEqualObjects([r valueForKey:@"question"], @"q10", @"Wrong question");
    STAssertEqualObjects([r valueForKey:@"answer"], @"a10", @"Wrong answer");
    STAssertEqualObjects([r valueForKey:@"value"], @"woot", @"Wrong response value");
}

- (void)testPopulateResponseSetWithMissingResponseSetAndSurveyId {
    ResponseSet* act = [surveySet populateResponseSet:nil forSurveyId:nil];
    STAssertNil(act, @"Should be nil");
}

- (void)testPopulateResponseSetWithPickOne {
    [responseSetA newResponseForQuestion:@"q2" Answer:@"a3" Value:nil];
    ResponseSet* act = [surveySet populateResponseSet:nil forSurveyId:@"survey-b"];
    STAssertEqualObjects([act valueForKey:@"survey"], @"survey-b", @"Wrong survey id");
    STAssertEqualObjects([act valueForKey:@"pId"], @"yak423", @"Wrong pId");
    STAssertEquals((int)[[act responses] count], 2, @"Should be 1");
    NUResponse* r = [[act responsesForQuestion:@"q11" Answer:@"a12"] lastObject];
    STAssertEqualObjects([r valueForKey:@"question"], @"q11", @"Wrong question");
    STAssertEqualObjects([r valueForKey:@"answer"], @"a12", @"Wrong answer");
    STAssertNil([r valueForKey:@"value"], @"Wrong response value");
}

#pragma mark - QuestionRef#questionDictByAttribute

- (void)testQuestionDictByAttribute {
//    NSDictionary* act = [surveySet questionDictByRefIdForSurvey:surveyB];
//    STAssertEquals((int) [act count], 1, @"Wrong number of questions");
//    STAssertEqualObjects([[[act allKeys] objectEnumerator] nextObject], @"pre_populated_name", @"Wrong reference identifier");
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

- (PrePopulatedQuestionRefSet*) destRefId:(NSString*)destRefId srcDataExpId:(NSString*)srcExpId {
    QuestionRef* src = [[QuestionRef alloc] initWithAttribute:@"data_export_identifier" value:srcExpId];
    QuestionRef* dest = [[QuestionRef alloc] initWithAttribute:@"reference_identifier" value:destRefId];
    return [[PrePopulatedQuestionRefSet alloc] initWithSource:src destination:dest];
}

@end
