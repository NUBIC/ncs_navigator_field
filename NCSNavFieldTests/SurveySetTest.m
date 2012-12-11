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
         "    \"title\":\"zang\","
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
         "    \"title\":\"zeek\","
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
         "  },{"
         "    \"title\":\"zork\""
         "  }]"
         "}";
    
    responseSetA = [self createResponseSetWithSurveyId:@"survey-a" participantId:participant.pId];
    [responseSetA newResponseForQuestion:@"q1" Answer:@"a1" Value:@"woot"];
    
    participant = [self createParticipant:@"yak423"];
    responseSetB = [self createResponseSetWithSurveyId:@"survey-b" participantId:participant.pId];
    
    surveySet = [[SurveySet alloc] initWithSurveys:[NSArray arrayWithObjects:surveyA,surveyB,nil] andResponseSets:[NSArray arrayWithObject:responseSetA]];
}

#pragma mark - SurveySet#SectionforSurveyIndex:SectionIndex

- (void)testSectionforSurveyIndex {
    NSDictionary* s = [surveySet sectionforSurveyIndex:0 sectionIndex:0];
    STAssertEqualObjects([s objectForKey:@"title"], @"zang", @"Wrong section");
}

- (void)testSectionforSurveyIndexWhenSurveyOutOfUpperBounds {
    NSDictionary* s = [surveySet sectionforSurveyIndex:99 sectionIndex:0];
    STAssertNil(s, @"Should not exist");
}

- (void)testSectionforSurveyIndexWhenSectionOutOfUpperBounds {
    NSDictionary* s = [surveySet sectionforSurveyIndex:0 sectionIndex:99];
    STAssertNil(s, @"Should not exist");
}

- (void)testPreviousSectionForSurveyIndex {
    NSDictionary* s = [surveySet previousSectionfromSurveyIndex:1 sectionIndex:1];
    STAssertEqualObjects([s objectForKey:@"title"], @"zeek", @"Wrong section");
}

- (void)testPreviousSectionForSurveyIndexWhenFirstSection {
    NSDictionary* s = [surveySet previousSectionfromSurveyIndex:1 sectionIndex:0];
    STAssertEqualObjects([s objectForKey:@"title"], @"zang", @"Wrong section");
}

- (void)testNextSectionForSurveyIndex {
    NSDictionary* s = [surveySet nextSectionfromSurveyIndex:1 sectionIndex:0];
    STAssertEqualObjects([s objectForKey:@"title"], @"zork", @"Wrong section");
}

- (void)testNextSectionForSurveyIndexWhenLastSection {
    NSDictionary* s = [surveySet nextSectionfromSurveyIndex:0 sectionIndex:0];
    STAssertEqualObjects([s objectForKey:@"title"], @"zeek", @"Wrong section");
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

@end
