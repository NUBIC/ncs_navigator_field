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

@implementation ResponseTest

- (void)testToDictForIntegerAnswers {
    NUAnswer* a = [NUAnswer object];
    a.uuid = @"ruff";
    a.type = @"integer";
    
    NUQuestion* q = [NUQuestion object];
    q.uuid = @"woof";
    q.text = @"How many dogs?";
    [q addAnswersObject:a];
    
    
    Response* r = [Response object];
    [r setValue:@"woof" forKey:@"question"];
    [r setValue:@"ruff" forKey:@"answer"];
    [r setValue:@"4" forKey:@"value"];
    
    STAssertEqualObjects([r toDict][@"value"], @4, nil);
}

@end
