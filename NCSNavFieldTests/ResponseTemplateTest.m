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
#import "NUQuestion.h"
#import <NUSurveyor/NUSurvey.h>
#import "NUSurvey+Additions.h"
#import <JSONKit/JSONKit.h>

@implementation ResponseTemplateTest

- (void)testSurvey {
    InstrumentTemplate* it1 = [InstrumentTemplate object];
    it1.representation = @"{\"title\":\"foo\", \"uuid\":\"bar\"}";
    
    InstrumentTemplate* it2 = [InstrumentTemplate object];
    it2.representation = @"{\"title\":\"boo\", \"uuid\":\"baz\"}";
    
    ResponseTemplate* rt = [ResponseTemplate object];
    rt.surveyId = @"baz";
    
    STAssertEqualObjects([[rt survey] uuid], @"baz", nil);
}

- (void)testQuestion {
    NSString* surveyJson  =
        @"{                                               "
        "   \"uuid\": \"baz\",                            "
        "   \"sections\": [                               "
        "     {                                           "
        "        \"title\": \"uno\",                      "
        "        \"questions_and_groups\": [              "
        "          { \"reference_identifier\": \"aye\" }, "
        "          { \"reference_identifier\": \"bee\" }  "
        "        ]                                        "
        "     }                                           "
        "   ]                                             "
        "}                                                ";
    
    InstrumentTemplate* it = [InstrumentTemplate object];
    it.representationDictionary = [surveyJson objectFromJSONString]
    ;
    
    STAssertNotNil(it.representationDictionary, nil);
    
    ResponseTemplate* rt = [ResponseTemplate object];
    rt.surveyId = @"baz";
    rt.qref = @"bee";
    
    STAssertEqualObjects([rt question].referenceIdentifier, @"bee", nil);
}

@end
