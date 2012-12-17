//
//  InstrumentTest.m
//  NCSNavField
//
//  Created by John Dzak on 4/11/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "InstrumentTest.h"
#import "Instrument.h"
#import "ResponseSet.h"
#import "InstrumentPlan.h"
#import "InstrumentTemplate.h"
#import "ResponseTemplate.h"
#import <OCMock/OCMock.h>

@implementation InstrumentTest

static Instrument* i;
static InstrumentTemplate* it;

- (void)setUp {
    [super setUp];
    i = [Instrument object];
    i.instrumentPlanId = @"IP-A1";
    
    InstrumentPlan* ip = [InstrumentPlan object];
    ip.instrumentPlanId = @"IP-A1";
    
    it = [InstrumentTemplate object];
    it.representation = @"{ \"title\":\"avc_v1.3\"}";
    [ip setInstrumentTemplates:[NSOrderedSet orderedSetWithObject:it]];

}

- (void)testSanity {
    Instrument* ins = [Instrument object];
    ins.instrumentId = @"12345";
    [[ins managedObjectContext] save:nil];
    Instrument* found = [Instrument findFirstByAttribute:@"instrumentId" withValue:@"12345"];
    STAssertEqualObjects(found.instrumentId, @"12345", @"Wrong id");
}

- (void)testDetermineInstrumentVersionFromSurveyTitleForDecimal {
    it.representation = @"{ \"title\":\"INS_QUE_PBSamplingScreen_INT_PBS_M3.0_V2.4\"}";
    STAssertEqualObjects([i determineInstrumentVersionFromSurveyTitle], @"2.4", nil);
}

- (void)testDetermineInstrumentVersionFromSurveyTitleForWholeNumber {
    it.representation = @"{ \"title\":\"INS_QUE_PBSamplingScreen_INT_PBS_M3.0_V1\"}";
    STAssertEqualObjects([i determineInstrumentVersionFromSurveyTitle], @"1", nil);
}

- (void)testDetermineInstrumentVersionFromSurveyTitleWhenPartOne {
    it.representation = @"{ \"title\":\"INS_QUE_ParticipantVerif_DCI_EHPBHILIPBS_M3.0_V1.0_PART_ONE\"}";
    STAssertEqualObjects([i determineInstrumentVersionFromSurveyTitle], @"1.0", nil);
}

- (void)testDetermineInstrumentVersion {
    it.representation = @"{ \"title\":\"INS_QUE_PBSamplingScreen_INT_PBS_M3.0_V2.5\"}";
    STAssertEqualObjects([i determineInstrumentVersion], @"2.5", nil);
    i.instrumentVersion = @"abc";
    STAssertEqualObjects([i determineInstrumentVersion], @"abc", nil);
}

- (void)testPopulateResponseSetsFromResponseTemplates {
    it.representation =
        @"{"
         "  \"uuid\":\"survey-a\",                                                  "
         "  \"sections\":[{                                                         "
         "    \"questions_and_groups\":[                                            "
         "      {                                                                   "
         "         \"reference_identifier\":\"foo\",                                "
         "         \"uuid\":\"f\",                                                   "
         "         \"answers\":[                                                    "
         "           {\"reference_identifier\":\"yes\", \"uuid\": \"foo_yes\" },    "
         "           {\"reference_identifier\":\"no\",  \"uuid\": \"foo_no\" }      "
         "         ]                                                                "
         "      },                                                                  "
         "      {                                                                   "
         "         \"reference_identifier\":\"bar\",                                "
         "         \"uuid\":\"b\",                                                  "
         "         \"answers\":[                                                    "
         "           {\"reference_identifier\":\"yes\", \"uuid\": \"bar_yes\" },    "
         "           {\"reference_identifier\":\"no\",  \"uuid\": \"bar_no\" }      "
         "         ]                                                                "
         "      },                                                                  "
         "      {                                                                   "
         "         \"reference_identifier\":\"moo\",                                "
         "         \"uuid\":\"m\",                                                  "
         "         \"answers\":[                                                    "
         "           {\"reference_identifier\":\"yes\", \"uuid\": \"moo_yes\" },    "
         "           {\"reference_identifier\":\"no\",  \"uuid\": \"moo_no\" }      "
         "         ]                                        "
         "      }                                           "
         "    ]                                             "
         "  }]                                              "
         "}                                                 ";
    STAssertNotNil(it.representationDictionary, nil);
    
    ResponseTemplate* rt0 = [ResponseTemplate object];
    rt0.qref = @"foo";
    rt0.aref = @"yes";
    rt0.surveyId = @"survey-a";
    [i addResponseTemplatesObject:rt0];
    
    ResponseTemplate* rt1 = [ResponseTemplate object];
    rt1.qref = @"moo";
    rt1.aref = @"no";
    rt1.surveyId = @"survey-a";
    [i addResponseTemplatesObject:rt1];
    
    STAssertEquals([[i responseSets] count], 0U, nil);
    [i createAndPopulateResponseSetsFromResponseTemplates];
    STAssertEquals([[i responseSets] count], 1U, nil);
    
    ResponseSet* actual = [[[i responseSets] objectEnumerator] nextObject];
    STAssertEquals([[actual responses] count], 2U, nil);
    STAssertNotNil([actual responsesForQuestion:@"f" Answer:@"foo_yes"], nil);
    STAssertNotNil([actual responsesForQuestion:@"m" Answer:@"moo_no"], nil);
}

@end
