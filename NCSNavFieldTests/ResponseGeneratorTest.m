//
//  ResponseGeneratorTest.m
//  NCSNavField
//
//  Created by John Dzak on 11/8/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "ResponseGeneratorTest.h"

#import "ResponseGenerator.h"
#import <NUSurveyor/NUSurvey.h>
#import <NUSurveyor/NUResponse.h>
#import "NUSurvey+Additions.h"

@implementation ResponseGeneratorTest

static NUSurvey* survey;

- (void)setUp {
    [super setUp];
    survey = [NUSurvey new];
    survey.jsonString =
       @"{                                                                      "
        "   \"sections\": [                                                     "
        "     {                                                                 "
        "       \"questions_and_groups\": [                                     "
        "         {                                                             "
        "           \"reference_identifier\": \"prepopulated_psu_id\",          "
        "           \"text\": \"PSU#\",                                         "
        "           \"uuid\": \"q1\",                                           "
        "           \"answers\": [                                              "
        "               {                                                       "
        "                   \"reference_identifier\": \"psu_id\",               "
        "                   \"type\": \"string\",                               "
        "                   \"uuid\": \"q1a1\"                                  "
        "               }                                                       "
        "            ]                                                          "
        "         },                                                            "
        "         {                                                             "
        "           \"reference_identifier\": \"prepopulated_practice_num\",    "
        "           \"text\": \"PRACTICE#\",                                    "
        "           \"uuid\": \"q2\",                                           "
        "           \"answers\": [                                              "
        "             {                                                         "
        "               \"reference_identifier\": \"practice_num\",             "
        "               \"type\": \"string\",                                   "
        "                \"uuid\": \"q2a1\"                                     "
        "             }                                                         "
        "           ]                                                           "
        "         }                                                             "
        "       ]                                                               "
        "     },                                                                "
        "     {                                                                 "
        "       \"questions_and_groups\": [                                     "
        "         {                                                             "
        "           \"reference_identifier\": \"prepopulated_name\",            "
        "           \"text\": \"Name\",                                         "
        "           \"uuid\": \"q3\",                                           "
        "           \"answers\": [                                              "
        "               {                                                       "
        "                   \"reference_identifier\": \"name\",                 "
        "                   \"type\": \"string\",                               "
        "                   \"uuid\": \"q3a1\"                                  "
        "               }                                                       "
        "            ]                                                          "
        "         },                                                            "
        "         {                                                             "
        "           \"reference_identifier\": \"address\",                      "
        "           \"text\": \"Address\",                                      "
        "           \"uuid\": \"q4\",                                           "
        "           \"answers\": [                                              "
        "             {                                                         "
        "               \"reference_identifier\": \"address\",                  "
        "               \"type\": \"string\",                                   "
        "                \"uuid\": \"q4a1\"                                     "
        "             }                                                         "
        "           ]                                                           "
        "         },                                                            "
        "         {                                                             "
        "           \"reference_identifier\": \"PREPOPULATED_SEX\",             "
        "           \"text\": \"Sex\",                                          "
        "           \"uuid\": \"q5\",                                           "
        "           \"answers\": [                                              "
        "             {                                                         "
        "               \"reference_identifier\": \"sex\",                      "
        "               \"type\": \"string\",                                   "
        "                \"uuid\": \"q5a1\"                                     "
        "             }                                                         "
        "           ]                                                           "
        "         }                                                             "
        "       ]                                                               "
        "     }                                                                 "
        "   ]                                                                   "
        "}                                                                      ";
}

- (void)testSurveyJsonIsValid {
    STAssertNotNil([survey deserialized], @"Survey JSON is not valid");
}

- (void)testPrepopulatedQuestions {
    ResponseGenerator* g = [[ResponseGenerator alloc] initWithSurvey:survey context:nil];
    STAssertEquals([[g prepopulatedQuestions:survey] count], 4U, nil);
}

- (void)testParsePrepopulatedPostTextForReferenceIdentifier {
    ResponseGenerator* g = [[ResponseGenerator alloc] initWithSurvey:survey context:nil];
    STAssertEqualObjects([g parsePrepopulatedPostTextForReferenceIdentifier:@"prepopulated_foo"], @"foo", nil);
}

- (void)testParsePrepopulatedPostTextForReferenceIdentifierWithNil {
    ResponseGenerator* g = [[ResponseGenerator alloc] initWithSurvey:survey context:nil];
    STAssertNil([g parsePrepopulatedPostTextForReferenceIdentifier:nil], nil);
}

- (void)testParsePrepopulatedPostTextForReferenceIdentifierWithNoPrepopulated {
    ResponseGenerator* g = [[ResponseGenerator alloc] initWithSurvey:survey context:nil];
    STAssertNil([g parsePrepopulatedPostTextForReferenceIdentifier:@"foo"], nil);
}

- (void)testGenerateResponses {
    NSDictionary* context = @{@"psu_id": @"Whoohoo PSU"};
    ResponseGenerator* g = [[ResponseGenerator alloc] initWithSurvey:survey context:context];
    NSArray* actual = [g responses];
    STAssertEquals([actual count], 1U, nil);
    NUResponse* r0 = actual[0];
    STAssertEqualObjects([r0 valueForKey:@"value"], @"Whoohoo PSU", nil);
}

- (void)testGenerateResponsesWithMultipleContextItems {
    NSDictionary* context = @{@"psu_id": @"Whoohoo PSU", @"practice_num": [NSNumber numberWithInt:3]};
    ResponseGenerator* g = [[ResponseGenerator alloc] initWithSurvey:survey context:context];
    NSArray* actual = [g responses];
    STAssertEquals([actual count], 2U, nil);
    NUResponse* r0 = actual[0];
    STAssertEqualObjects([r0 valueForKey:@"value"], @"Whoohoo PSU", nil);
    NUResponse* r1 = actual[1];
    STAssertEqualObjects([r1 valueForKey:@"value"], @"3", nil);
}

- (void)testGenerateResponsesAcrossSections {
    NSDictionary* context = @{@"psu_id": @"Whoohoo PSU", @"name": @"Fred"};
    ResponseGenerator* g = [[ResponseGenerator alloc] initWithSurvey:survey context:context];
    NSArray* actual = [g responses];
    STAssertEquals([actual count], 2U, nil);
    NUResponse* r0 = actual[0];
    STAssertEqualObjects([r0 valueForKey:@"value"], @"Whoohoo PSU", nil);
    NUResponse* r1 = actual[1];
    STAssertEqualObjects([r1 valueForKey:@"value"], @"Fred", nil);
}

- (void)testGenerateResponsesWithBlankContext {
    NSDictionary* context = @{};
    ResponseGenerator* g = [[ResponseGenerator alloc] initWithSurvey:survey context:context];
    STAssertEquals([[g responses] count], 0U, nil);
}

- (void)testGenerateResponsesWithNilContext {
    NSDictionary* context = nil;
    ResponseGenerator* g = [[ResponseGenerator alloc] initWithSurvey:survey context:context];
    STAssertEquals([[g responses] count], 0U, nil);
}

- (void)testGenerateResponsesWithCapitalizedQuestionReferenceIdentifiers {
    NSDictionary* context = @{ @"sex": @"male" };
    ResponseGenerator* g = [[ResponseGenerator alloc] initWithSurvey:survey context:context];
    NSArray* actual = [g responses];
    STAssertEquals([actual count], 1U, nil);
    NUResponse* r0 = actual[0];
    STAssertEqualObjects([r0 valueForKey:@"value"], @"male", nil);
}

@end
