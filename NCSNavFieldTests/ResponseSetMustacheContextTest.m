//
//  ResponseSetMustacheContextTest.m
//  NCSNavField
//
//  Created by John Dzak on 2/20/13.
//  Copyright (c) 2013 Northwestern University. All rights reserved.
//

#import "ResponseSetMustacheContextTest.h"
#import "ResponseSet.h"
#import "Response.h"
#import "NUQuestion.h"
#import "NUAnswer.h"
#import "ResponseSetMustacheContext.h"
#import "InstrumentTemplate.h"

@implementation ResponseSetMustacheContextTest

- (void)testToDictionaryNotNil {
    ResponseSet* rs = [ResponseSet object];
    ResponseSetMustacheContext* ctx = [[ResponseSetMustacheContext alloc] initWithResponseSet:rs];
    NSDictionary* actual = [ctx toDictionary];
    STAssertNotNil(actual, nil);
}

- (void)testToDictionary {
    InstrumentTemplate* instrumentTemplate = [InstrumentTemplate object];
    instrumentTemplate.instrumentTemplateId = @"inst-temp-1";
    instrumentTemplate.representation = @"{\"uuid\": \"inst-temp-1\"}";

    NUQuestion* question = [NUQuestion object];
    question.uuid = @"q1";
    question.referenceIdentifier = @"helper_foo";
    question.instrumentTemplate = instrumentTemplate;
    
    NUAnswer* answer = [NUAnswer object];
    answer.uuid = @"q1a1";
    
    Response* response = [Response object];
    response.question = @"q1";
    response.answer = @"q1a1";
    response.value = @"bar";

    
    ResponseSet* rs = [ResponseSet object];
    rs.responses = [NSSet setWithObject:response];
    rs.survey = @"inst-temp-1";
    

    
    ResponseSetMustacheContext* ctx = [[ResponseSetMustacheContext alloc] initWithResponseSet:rs];
    NSDictionary* actual = [ctx toDictionary];
    STAssertEquals([actual count], 1U, nil);
    STAssertEqualObjects(actual[@"foo"], @"bar", nil);
}
@end
