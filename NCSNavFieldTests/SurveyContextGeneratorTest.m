//
//  SurveyContextGenerator.m
//  NCSNavField
//
//  Created by John Dzak on 11/8/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "SurveyContextGeneratorTest.h"

#import "SurveyContextGenerator.h"
#import "Provider.h"

@implementation SurveyContextGeneratorTest

static Provider* provider;

- (void)setUp {
    [super setUp];
    provider = [Provider object];
    provider.name = @"Northwestern";
    provider.location = @"XYZ123";
    provider.practiceNum = [NSNumber numberWithInt:4];
}

- (void)testContext {
    SurveyContextGenerator* g = [[SurveyContextGenerator alloc] initWithProvider:provider];
    NSDictionary* actual = [g context];
    STAssertEqualObjects(actual[@"name_practice"], @"Northwestern", nil);
    STAssertEqualObjects(actual[@"provider_id"], @"XYZ123", nil);
    STAssertEqualObjects(actual[@"practice_num"], [NSNumber numberWithInt:4], nil);
}

@end
