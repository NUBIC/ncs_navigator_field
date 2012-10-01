//
//  SurveySeries.m
//  NCSNavField
//
//  Created by John Dzak on 10/1/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "SurveySet.h"
#import "ResponseSet.h"
#import "Participant.h"
#import <MRCEnumerable/MRCEnumerable.h>
#import <NUSurveyor/NUSurvey.h>
#import "NUSurvey+Additions.h"

@implementation SurveySet

@synthesize surveys = _surveys;
@synthesize responseSets = _responseSets;
@synthesize participant = _participant;

- (id)initWithSurveys:(NSArray*)s andResponseSets:(NSArray*)rs forParticipant:(Participant*)p {
    if (self = [self init]) {
        _surveys = [s retain];
        _responseSets = [rs retain];
        _participant = [p retain];
    }
    return self;
}

- (ResponseSet*)generateResponseSetForSurveyId:(NSString*)sid {
    ResponseSet* rs = [ResponseSet object];
    [rs setValue:self.participant.pId forKey:@"pId"];
    [rs setValue:sid forKey:@"survey"];
    return rs;
}

- (ResponseSet*)populateResponseSet:(ResponseSet*)rs forSurveyId:sid {
    NSArray* pre = [self preopulatedQuestionsForSurveyId:sid];
    [self applyPrePopulatedQuestions:pre toResponseSet:rs];
    return rs;
}

- (void)applyPrePopulatedQuestions:(NSArray*)pre toResponseSet:(ResponseSet*)rs {
    for (NSDictionary* question in pre) {
        if ([[question objectForKey:@"reference_identifier"] isEqualToString:@"foo"]) {
            [rs newResponseForQuestion:@"que-a" Answer:@"ans-a" Value:@"bar"];
        }
    }
}

// TODO: Move to surveyor
- (NSArray*)preopulatedQuestionsForSurveyId:(NSString*)sid {
    NSMutableArray* result = [NSMutableArray new];
    NUSurvey* found = [self.surveys detect:^BOOL(NUSurvey* s){
        return [[s uuid] isEqualToString:sid];
    }];
    if (found) {
        for (NSDictionary* section in [[found deserialized] valueForKey:@"sections"]) {
            for (NSDictionary* questionOrGroup in [section valueForKey:@"questions_and_groups"]) {
                if ([[questionOrGroup valueForKey:@"reference_identifier"] isEqualToString:@"foo"]) {
                    [result addObject:questionOrGroup];
                }
                for (NSDictionary* groupQuestion in [section valueForKey:@"questions"]) {
                    // TODO: Implement Me
                    NSLog(@"Implement Me");
                }
            }
        }        
    }
    return result;
}


- (void)dealloc {
    [_surveys release];
    [_responseSets release];
    [_participant release];
    [super dealloc];
}

@end
