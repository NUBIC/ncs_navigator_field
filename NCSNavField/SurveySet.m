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
#import <NUSurveyor/NUResponseSet.h>
#import <NUSurveyor/NUResponse.h>
#import "NUResponse+Additions.h"

@implementation SurveySet

@synthesize surveys = _surveys;
@synthesize responseSets = _responseSets;
@synthesize participant = _participant;

- (id)initWithSurveys:(NSArray*)s andResponseSets:(NSArray*)rs forParticipant:(Participant*)p {
    if (self = [self init]) {
        _surveys = [s retain];
        _responseSets = [rs retain];
        _participant = [p retain];
        
        _prepopulatedQuestionRefs = [[self defaultPrepopulatedQuestionRefs] retain];
    }
    return self;
}

- (NSArray*) defaultPrepopulatedQuestionRefs {
    return [NSArray arrayWithObjects:
            [self destRefId:@"pre_populated_foo" srcDataExpId:@"bar"], nil];
}

- (PrePopulatedQuestionRefSet*) destRefId:(NSString*)destRefId srcDataExpId:(NSString*)srcExpId {
    QuestionRef* src = [[[QuestionRef alloc] initWithAttribute:@"data_export_identifier" value:srcExpId] autorelease];
    QuestionRef* dest = [[[QuestionRef alloc] initWithAttribute:@"reference_identifier" value:destRefId] autorelease];
    return [[[PrePopulatedQuestionRefSet alloc] initWithSource:src destination:dest] autorelease];
}

- (ResponseSet*)generateResponseSetForSurveyId:(NSString*)sid {
    ResponseSet* rs = [ResponseSet object];
    [rs setValue:self.participant.pId forKey:@"pId"];
    [rs setValue:sid forKey:@"survey"];
    return rs;
}

- (ResponseSet*)populateResponseSet:(ResponseSet*)rs forSurveyId:sid {
    NSArray* pre = [self prePopulatedResponsesForSurveyId:sid];
    [self applyPrePopulatedResponses:pre toResponseSet:rs];
    [[NSManagedObjectContext contextForCurrentThread] save:nil];
    return rs;
}

- (void)applyPrePopulatedResponses:(NSArray*)pre toResponseSet:(ResponseSet*)rs {
    for (NUResponse* r in pre) {
        NUResponse* existing = [[rs responsesForQuestion:[r valueForKey:@"question"] Answer:[r valueForKey:@"answer"]] lastObject];
        if (existing) {
            [existing setValue:[r valueForKey:@"value"] forKey:@"value"];
        } else {
            [rs newResponseForQuestion:[r valueForKey:@"question"] Answer:[r valueForKey:@"answer"] Value:[r valueForKey:@"value"]];
        }
    }
}

// TODO: Move to surveyor
- (NSArray*)prePopulatedResponsesForSurveyId:(NSString*)sid {
    NSMutableArray* result = [[NSMutableArray new] autorelease];
    NUSurvey* dstSurvey = [self findSurveyByUUID:sid inSurveys:self.surveys];
    if (dstSurvey) {
        for (PrePopulatedQuestionRefSet* pqrs in self.prepopulatedQuestionRefs) {
            NSDictionary* dstQuestion = [self findQuestionDictByQuestionRef:pqrs.dest inSurveys:[NSArray arrayWithObject:dstSurvey]];
            NSDictionary* dstAnswer = [[[dstQuestion objectForKey:@"answers"] objectEnumerator] nextObject];
            
            if (dstQuestion && dstAnswer) {
                NUResponse* transient = [NUResponse transient];
                [transient setValue:[dstQuestion valueForKey:@"uuid"] forKey:@"question"];
                [transient setValue:[dstAnswer valueForKey:@"uuid"] forKey:@"answer"];
                
                NSDictionary* srcQuestion = [self findQuestionDictByQuestionRef:pqrs.src inSurveys:self.surveys];
                NUResponse* srcResponse = [self findResponseByQuestionUUID:[srcQuestion valueForKey:@"uuid"] inResponseSets:self.responseSets];
                [transient setValue:[srcResponse valueForKey:@"value"] forKey:@"value"];
                [result addObject:transient];
            }
        }
    }
    return result;
}

- (NUSurvey*)findSurveyByUUID:(NSString*)uuid inSurveys:(NSArray*)surveys {
    return [surveys detect:^BOOL(NUSurvey* s){
        return [[s uuid] isEqualToString:uuid];
    }];
}


- (NSDictionary*)findQuestionDictByQuestionRef:(QuestionRef*)ref inSurveys:(NSArray*)surveys {
    for (NUSurvey* s in surveys) {
        NSDictionary* questionsByIdentifier = [self questionDictByAttribute:ref.attribute forSurvey:s];
        if ([questionsByIdentifier objectForKey:ref.value]) {
            return [questionsByIdentifier objectForKey:ref.value];
        }
    }
    return nil;
}

- (NSDictionary*) questionDictByAttribute:(NSString*)attr forSurvey:(NUSurvey*)survey {
    NSMutableDictionary* result = [[NSMutableDictionary new] autorelease];
    for (NSDictionary* section in [[survey deserialized] valueForKey:@"sections"]) {
        for (NSDictionary* questionOrGroup in [section valueForKey:@"questions_and_groups"]) {
            if ([questionOrGroup valueForKey:attr]) {
                [result setValue:questionOrGroup forKey:[questionOrGroup valueForKey:attr]];
            }
            for (NSDictionary* groupQuestion in [section valueForKey:@"questions"]) {
                if ([groupQuestion valueForKey:attr]) {
                    [result setValue:groupQuestion forKey:[groupQuestion valueForKey:attr]];
                }
            }
        }
    }
    return result;
}

- (NUResponse*)findResponseByQuestionUUID:(NSString*)uuid inResponseSets:(NSArray*)responseSets {
    for (ResponseSet* rs in responseSets) {
        return [[rs responsesForQuestion:uuid] lastObject];
    }
    return nil;
}

- (void)dealloc {
    [_surveys release];
    [_responseSets release];
    [_participant release];
    [_prepopulatedQuestionRefs release];
    [super dealloc];
}

@end

#pragma mark - QuestionRef

@implementation QuestionRef

@synthesize attribute = _attribute, value = _value;

- (id)initWithAttribute:(NSString*)attr value:(NSString*)value {
    if (self = [self init]) {
        _attribute = [attr retain];
        _value = [value retain];
    }
    return self;
}

- (void)dealloc {
    [_attribute release];
    [_value release];
    [super dealloc];
}

@end

#pragma mark - PrepopulatedQuestionRef

@implementation PrePopulatedQuestionRefSet

@synthesize src = _src, dest = _dest;

- (id)initWithSource:(QuestionRef*)src destination:(QuestionRef*)dest {
    if (self = [self init]) {
        _src = [src retain];
        _dest = [dest retain];
    }
    return self;
}

- (void)dealloc {
    [_src release];
    [_dest release];
    [super dealloc];
}

@end
