//
//  SurveySetTest.m
//  NCSNavField
//
//  Created by John Dzak on 10/1/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "SurveySetTest.h"
#import "SurveySet.h"
#import "ResponseSet.h"
#import "Participant.h"

@implementation SurveySetTest

#pragma mark - SurveySet#generateResponseSet

- (void) testEmptyResponseSetGenerated {
    Participant *p = [Participant object];
    p.pId = @"yak423";
    SurveySet* ss = [[[SurveySet alloc] initWithSurveys:[NSArray array] andResponseSets:[NSArray array] forParticipant:p] autorelease];
    ResponseSet* rs = [ss generateResponseSetForSurveyId:@"abc"];
    STAssertEqualObjects([rs valueForKey:@"survey"], @"abc", @"Wrong survey id");
    STAssertEqualObjects([rs valueForKey:@"pId"], @"yak423", @"Wrong pId");
    STAssertFalse([[rs responses] count] > 0, @"Should be empty");
}

@end
