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

- (void)testDetermineInstrumentVersionFromSurveyTitle {
    it.representation = @"{ \"title\":\"v1 bad title\"}";
    STAssertNil([i determineInstrumentVersionFromSurveyTitle], nil);
}

- (void)testDetermineInstrumentVersion {
    it.representation = @"{ \"title\":\"INS_QUE_PBSamplingScreen_INT_PBS_M3.0_V2.5\"}";
    STAssertEqualObjects([i determineInstrumentVersion], @"2.5", nil);
    i.instrumentVersion = @"abc";
    STAssertEqualObjects([i determineInstrumentVersion], @"abc", nil);
}

@end
