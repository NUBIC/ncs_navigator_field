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
    return [[[NSMutableArray alloc] initWithObjects:
             [[[PrepopulatedQuestionRef alloc] initWithReferenceIdentifier:@"pre_populated_foo" dataExportIdentifier:@"bar"] autorelease], nil] autorelease];
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
    NUSurvey* dstSurvey = [self findByUUID:sid inSurveys:self.surveys];
    if (dstSurvey) {
        NSDictionary* questionsByRefId = [self questionDictByRefIdForSurvey:dstSurvey];
        for (NSString* refId in [[self prePopulatedQuestionRefDictByRefId] allKeys]) {
            NSDictionary* dstQuestion = [questionsByRefId objectForKey:refId];
            NSDictionary* dstAnswer = [[[dstQuestion objectForKey:@"answers"] objectEnumerator] nextObject];
            if (dstQuestion && dstAnswer) {
                NUResponse* transient = [NUResponse transient];
                [transient setValue:[dstQuestion valueForKey:@"uuid"] forKey:@"question"];
                [transient setValue:[dstAnswer valueForKey:@"uuid"] forKey:@"answer"];
                PrepopulatedQuestionRef* ref = [[self prePopulatedQuestionRefDictByRefId] objectForKey:refId];
                NSDictionary* srcQuestion = [self findQuestionDictByDataExportIdentifier:ref.dataExportIdentifier inSurveys:self.surveys];
                NUResponse* srcResponse = [self findResponseByQuestionUUID:[srcQuestion valueForKey:@"uuid"] inResponseSets:self.responseSets];
                [transient setValue:[srcResponse valueForKey:@"value"] forKey:@"value"];
                [result addObject:transient];
            }
        }
    }
    return result;
}

- (NUSurvey*)findByUUID:(NSString*)uuid inSurveys:(NSArray*)surveys {
    return [surveys detect:^BOOL(NUSurvey* s){
        return [[s uuid] isEqualToString:uuid];
    }];
}

- (NSDictionary*) questionDictByRefIdForSurvey:(NUSurvey*)survey {
    return [self questionDictByAttribute:@"reference_identifier" forSurvey:survey];
}

- (NSDictionary*) questionDictByDataExportIdForSurvey:(NUSurvey*)survey {
    return [self questionDictByAttribute:@"data_export_identifier" forSurvey:survey];
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


- (NSDictionary*) prePopulatedQuestionRefDictByRefId {
    NSMutableDictionary* result = [[NSMutableDictionary new] autorelease];
    for (PrepopulatedQuestionRef* ref in self.prepopulatedQuestionRefs) {
        [result setValue:ref forKey:ref.referenceIdentifier];
    }
    return result;
}

- (NSDictionary*)findQuestionDictByDataExportIdentifier:(NSString*)dei inSurveys:(NSArray*)surveys {
    for (NUSurvey* s in surveys) {
        NSDictionary* questionsByDEI = [self questionDictByDataExportIdForSurvey:s];
        if ([questionsByDEI objectForKey:dei]) {
            return [questionsByDEI objectForKey:dei];
        }
    }
    return nil;
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

#pragma mark - PrepopulatedQuestionRef

@implementation PrepopulatedQuestionRef

- (id)initWithReferenceIdentifier:(NSString*)rid dataExportIdentifier:(NSString*)deid {
    if (self = [self init]) {
        _referenceIdentifier = [rid retain];
        _dataExportIdentifier = [deid retain];
    }
    return self;
}

- (void)dealloc {
    [_referenceIdentifier release];
    [_dataExportIdentifier release];
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
