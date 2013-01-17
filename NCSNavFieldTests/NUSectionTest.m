//
//  NUSectionTest.m
//  NCSNavField
//
//  Created by John Dzak on 12/14/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "NUSectionTest.h"
#import "NUSection.h"
#import "NUQuestion.h"
#import <JSONKit/JSONKit.h>

@implementation NUSectionTest

- (void) testQuestions {
    NSString* sectionJson =
        @"{                            "
         "  \"questions_and_groups\":[ "
         "    { \"text\": \"hello\"},  "
         "    { \"text\": \"world\"}   "
         "  ]                          "
         "}                            ";
    NSDictionary* dSection = [sectionJson objectFromJSONString];
    
    STAssertNotNil(dSection, @"JSON is not valid");
    
    NUSection* s = [[NUSection alloc] initWithDictionary:dSection];
    
    NSArray* actual = [s questions];
    STAssertEquals([actual count], 2U, nil);
    STAssertEqualObjects([[actual objectAtIndex:0] text], @"hello", nil);
    STAssertEqualObjects([[actual objectAtIndex:1] text], @"world", nil);
}

- (void)testQuestionsInGroup {
    NSString* sectionJson =
    @"{                            "
    "  \"questions_and_groups\":[  "
    "    {                         "
    "      \"questions\" : [       "
    "        { \"text\": \"fred\"} "
    "      ]                       "
    "    }                         "
    "  ]                           "
    "}                             ";
    
    NSDictionary* dSection = [sectionJson objectFromJSONString];
    
    STAssertNotNil(dSection, @"JSON is not valid");
    
    NUSection* s = [[NUSection alloc] initWithDictionary:dSection];
    
    NSArray* actual = [s questions];
    STAssertEquals([actual count], 1U, nil);
    STAssertEqualObjects([[actual objectAtIndex:0] text], @"fred", nil);
}
@end
