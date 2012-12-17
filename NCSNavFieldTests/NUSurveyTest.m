//
//  NUSurveyTest.m
//  NCSNavField
//
//  Created by John Dzak on 12/14/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "NUSurveyTest.h"
#import <NUSurveyor/NUSurvey.h>
#import "NUSurvey+Additions.h"

@implementation NUSurveyTest

- (void)testSections {
    NSString* surveyJson =
        @"{                           "
         "   \"sections\": [          "
         "     { \"title\": \"uno\"}, "
         "     { \"title\": \"dos\"}  "
         "   ]                        "
         "}                           ";
    
    NUSurvey* s = [NUSurvey new];
    s.jsonString = surveyJson;
    
    STAssertNotNil(s.deserialized, nil);
    
    NSArray* actual = [s sections];
    STAssertEqualObjects([[actual objectAtIndex:0] title], @"uno", nil);
    STAssertEqualObjects([[actual objectAtIndex:1] title], @"dos", nil);
}

@end
