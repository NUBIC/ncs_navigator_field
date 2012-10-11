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
@synthesize prePopulatedQuestionRefs = _prePopulatedQuestionRefs;

- (id)initWithSurveys:(NSArray*)s andResponseSets:(NSArray*)rs forParticipant:(Participant*)p {
    if (self = [self init]) {
        _surveys = [s retain];
        _responseSets = [rs retain];
        _participant = [p retain];
        
        _prePopulatedQuestionRefs = [[self defaultPrePopulatedQuestionRefs] retain];
    }
    return self;
}

- (NSArray*) defaultPrePopulatedQuestionRefs {
    return [NSArray arrayWithObjects:
//            [self destRefId:@"prepopulated_name" srcDataExpId:nil],
//            [self destRefId:@"prepopulated_date_of_birth" srcDataExpId:nil],
//            [self destRefId:@"prepopulated_ppg_status" srcDataExpId:nil],
//            [self destRefId:@"prepopulated_local_sc" srcDataExpId:nil],
//            [self destRefId:@"prepopulated_sc_phone_number" srcDataExpId:nil],
//            [self destRefId:@"prepopulated_baby_name" srcDataExpId:nil],
//            [self destRefId:@"prepopulated_childs_birth_date" srcDataExpId:nil],
            [self destRefId:@"pre_populated_release_answer_from_part_one" srcDataExpId:@"BIRTH_VISIT_LI.RELEASE"],
            [self destRefId:@"pre_populated_mult_child_answer_from_part_one_for_6MM" srcDataExpId:@"SIX_MTH_MOTHER.MULT_CHILD"],
            [self destRefId:@"pre_populated_mult_child_answer_from_part_one_for_12MM" srcDataExpId:@"TWELVE_MTH_MOTHER.MULT_CHILD"],
            [self destRefId:@"pre_populated_mult_child_answer_from_part_one_for_18MM" srcDataExpId:@"EIGHTEEN_MTH_MOTHER.MULT_CHILD"],
            [self destRefId:@"pre_populated_mult_child_answer_from_part_one_for_24MM" srcDataExpId:@"TWENTY_FOUR_MTH_MOTHER.MULT_CHILD"],
            [self destRefId:@"pre_populated_child_qnum_answer_from_mother_detail_for_18MM" srcDataExpId:@"EIGHTEEN_MTH_MOTHER_DETAIL.CHILD_QNUM"],
            [self destRefId:@"pre_populated_child_qnum_answer_from_mother_detail_for_24MM" srcDataExpId:@"TWENTY_FOUR_MTH_MOTHER_DETAIL.CHILD_QNUM"], nil];
}

- (PrePopulatedQuestionRefSet*) destRefId:(NSString*)destRefId srcDataExpId:(NSString*)srcExpId {
    QuestionRef* src = [[[QuestionRef alloc] initWithAttribute:@"data_export_identifier" value:srcExpId] autorelease];
    QuestionRef* dest = [[[QuestionRef alloc] initWithAttribute:@"reference_identifier" value:destRefId] autorelease];
    return [[[PrePopulatedQuestionRefSet alloc] initWithSource:src destination:dest] autorelease];
}

- (ResponseSet*)generateResponseSetForSurveyId:(NSString*)sid {
    ResponseSet* rs = nil;
    if (sid) {
        rs = [ResponseSet object];
        [rs setValue:self.participant.pId forKey:@"pId"];
        [rs setValue:sid forKey:@"survey"];
    }
    return rs;
}

- (ResponseSet*)populateResponseSet:(ResponseSet*)rs forSurveyId:sid {
    if (!rs) {
        rs = [self generateResponseSetForSurveyId:sid];
    }
    NUSurvey* survey = [self findSurveyByUUID:sid inSurveys:self.surveys];
    NSArray* pre = [self prePopulatedResponsesForSurvey:survey];
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
- (NSArray*)prePopulatedResponsesForSurvey:(NUSurvey*)survey {
    NSMutableArray* result = [[NSMutableArray new] autorelease];
    if (survey) {
        for (PrePopulatedQuestionRefSet* pqrs in self.prePopulatedQuestionRefs) {
            NSDictionary* dstQuestion = [pqrs.dest resolveInSurvey:survey];
            
            if (dstQuestion) {
                NSDictionary* srcQuestion = [pqrs.src resolveInSurveys:self.surveys];
                NUResponse* srcResponse = [self findResponseByQuestionUUID:[srcQuestion valueForKey:@"uuid"] inResponseSets:self.responseSets];
                AnswerRef* srcAnswerRef = [[AnswerRef alloc] initWithAttribute:@"uuid" value:[srcResponse valueForKey:@"answer"]];
                NSDictionary* srcAnswer = [srcAnswerRef resolveInSurveys:self.surveys];
                
                AnswerRef* dstAnswerRef = [[AnswerRef alloc] initWithAttribute:@"reference_identifier" value:[srcAnswer valueForKey:@"reference_identifier"]];
                NSDictionary* dstAnswer = [dstAnswerRef resolveInSurvey:survey];
                if (!dstAnswer) {
                    dstAnswer = [[[dstQuestion objectForKey:@"answers"] objectEnumerator] nextObject];
                }
                
                if (dstQuestion && dstAnswer && srcResponse) {
                    NUResponse* transient = [NUResponse transient];
                    [transient setValue:[dstQuestion valueForKey:@"uuid"] forKey:@"question"];
                    [transient setValue:[dstAnswer valueForKey:@"uuid"] forKey:@"answer"];
                    [transient setValue:[srcResponse valueForKey:@"value"] forKey:@"value"];
                    [result addObject:transient];
                }
                
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

- (NUResponse*)findResponseByQuestionUUID:(NSString*)uuid inResponseSets:(NSArray*)responseSets {
    for (ResponseSet* rs in responseSets) {
        NUResponse* r = [[rs responsesForQuestion:uuid] lastObject];
        if (r) {
            return r;
        }
    }
    return nil;
}

- (void)dealloc {
    [_surveys release];
    [_responseSets release];
    [_participant release];
    [_prePopulatedQuestionRefs release];
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

- (NSDictionary*)resolveInSurvey:(NUSurvey*)survey {
    return [self resolveInSurveys:[NSArray arrayWithObject:survey]];
}

- (NSDictionary*)resolveInSurveys:(NSArray*)surveys {
    for (NUSurvey* s in surveys) {
        NSDictionary* questionsByIdentifier = [self questionDictByAttribute:self.attribute forSurvey:s];
        if ([questionsByIdentifier objectForKey:self.value]) {
            return [questionsByIdentifier objectForKey:self.value];
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

- (void)dealloc {
    [_attribute release];
    [_value release];
    [super dealloc];
}

@end


#pragma mark - AnswerRef

@implementation AnswerRef

@synthesize attribute = _attribute, value = _value;

- (id)initWithAttribute:(NSString*)attr value:(NSString*)value {
    if (self = [self init]) {
        _attribute = [attr retain];
        _value = [value retain];
    }
    return self;
}

- (NSDictionary*)resolveInSurvey:(NUSurvey*)survey {
    return [self resolveInSurveys:[NSArray arrayWithObject:survey]];
}

- (NSDictionary*)resolveInSurveys:(NSArray*)surveys {
    for (NUSurvey* s in surveys) {
        NSDictionary* questionsByIdentifier = [self questionDictByAttribute:self.attribute forSurvey:s];
        if ([questionsByIdentifier objectForKey:self.value]) {
            return [questionsByIdentifier objectForKey:self.value];
        }
    }
    return nil;
}

- (NSDictionary*) questionDictByAttribute:(NSString*)attr forSurvey:(NUSurvey*)survey {
    NSMutableDictionary* result = [[NSMutableDictionary new] autorelease];
    for (NSDictionary* section in [[survey deserialized] valueForKey:@"sections"]) {
        for (NSDictionary* questionOrGroup in [section valueForKey:@"questions_and_groups"]) {
            for (NSDictionary* answer in [questionOrGroup valueForKey:@"answers"]) {
                if ([answer valueForKey:attr]) {
                    [result setValue:answer forKey:[answer valueForKey:attr]];
                }
            }
            for (NSDictionary* groupQuestion in [section valueForKey:@"questions"]) {
                for (NSDictionary* answer in [groupQuestion valueForKey:@"answers"]) {
                    if ([answer valueForKey:attr]) {
                        [result setValue:answer forKey:[answer valueForKey:attr]];
                    }
                }
            }
        }
    }
    return result;
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