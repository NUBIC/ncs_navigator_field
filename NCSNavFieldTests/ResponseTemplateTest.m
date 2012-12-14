//
//  ResponseTemplateTest.m
//  NCSNavField
//
//  Created by John Dzak on 12/13/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "ResponseTemplateTest.h"
#import "ResponseTemplate.h"
#import "InstrumentTemplate.h"

@implementation ResponseTemplateTest

- (void)testSurvey {
    InstrumentTemplate* it1 = [InstrumentTemplate object];
    it1.representation = @"{\"title\":\"foo\", \"uuid\":\"bar\"}";
    
    InstrumentTemplate* it2 = [InstrumentTemplate object];
    it2.representation = @"{\"title\":\"boo\", \"uuid\":\"baz\"}";
    
    ResponseTemplate* rt = [ResponseTemplate object];
    rt.surveyId = @"baz";
    
    STAssertEqualObjects(it2, [rt survey], nil);
}

@end
