//
//  ResponseTest.m
//  NCSNavField
//
//  Created by John Dzak on 2/1/13.
//  Copyright (c) 2013 Northwestern University. All rights reserved.
//

#import "ResponseTest.h"
#import "NUAnswer.h"
#import "NUQuestion.h"
#import "Response.h"
#import "ResponseSet.h"

#import <JSONKit/JSONKit.h>
@implementation ResponseTest

static NUAnswer* ans;
static Response* res;

- (void)setUp {
    [super setUp];
    
    ans = [NUAnswer object];
    ans.uuid = @"ruff";
    ans.type = @"<unknown>";
    
    NUQuestion* qst = [NUQuestion object];
    qst.uuid = @"woof";
    qst.text = @"How many dogs?";
    [qst addAnswersObject:ans];
    
    
    res = [Response object];
    [res setValue:@"woof" forKey:@"question"];
    [res setValue:@"ruff" forKey:@"answer"];
}

- (void)testToDictForIntegerAnswer {
    ans.type = @"integer";
    [res setValue:@"4" forKey:@"value"];
    
    STAssertEqualObjects([res toDict][@"value"], @4, nil);
}

- (void)testToDictForIntegerAnswerWithNil {
    ans.type = @"integer";
    [res setValue:nil forKey:@"value"];
    
    STAssertEqualObjects([res toDict][@"value"], nil, nil);
}

- (void)testToDictForFloatAnswer {
    ans.type = @"float";
    [res setValue:@"3.14" forKey:@"value"];
    
    STAssertEqualObjects([res toDict][@"value"], [NSDecimalNumber decimalNumberWithString:@"3.14"], nil);
}

- (void)testToDictForStringAnswer {
    ans.type = @"string";
    [res setValue:@"bob" forKey:@"value"];
    
    STAssertEqualObjects([res toDict][@"value"], @"bob", nil);
}

- (void)testToDictForTextAnswer {
    ans.type = @"text";
    [res setValue:@"bob" forKey:@"value"];
    
    STAssertEqualObjects([res toDict][@"value"], @"bob", nil);
}

@end
