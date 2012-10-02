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
#import <NUSurveyor/NUResponse.h>
#import <NUSurveyor/NUResponse.h>

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
    return [[[NSMutableArray alloc] initWithObjects:[[[PrepopulatedQuestionRef alloc] initWithReferenceIdentifier:@"foo" dataExportIdentifier:@"bar"] autorelease], nil] autorelease];
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
        [rs newResponseForQuestion:[r valueForKey:@"question"] Answer:[r valueForKey:@"answer"] Value:[r valueForKey:@"value"]];
    }
}

// TODO: Move to surveyor
- (NSArray*)prePopulatedResponsesForSurveyId:(NSString*)sid {
    NSMutableArray* result = [[NSMutableArray new] autorelease];
//    NUSurvey* found = [self.surveys detect:^BOOL(NUSurvey* s){
//        return [[s uuid] isEqualToString:sid];
//    }];
//    if (found) {
//        NSDictionary* qs = [self questionDictByRefIdForSurvey:found];
//        NSArray* refIds = [[self prePopulatedQuestionRefDictByRefId] allKeys];
//        for (NSString* refId in refIds) {
//            NSDictionary* foundQ = [qs objectForKey:refId];
//            if (foundQ) {
//                NUResponse* r = [[NUResponse new] autorelease];
//                [r setValue:[foundQ valueForKey:@"question"] forKey:@"question"];
//                [r setValue:[foundQ valueForKey:@"answer"] forKey:@"answer"];
//                NUResponse* foundR = [[NUResponse findByAttribute:@"data_export_identifier" withValue:[[self prePopulatedQuestionRefDictByRefId] objectForKey:refId]] lastObject];
//                [r setValue:[foundR valueForKey:@"value"] forKey:@"value"];
//                [result addObject:r];
//            }
//        }
//    }
    return result;
}

- (NSDictionary*) prePopulatedQuestionRefDictByRefId {
    NSMutableDictionary* result = [[NSMutableDictionary new] autorelease];
    for (PrepopulatedQuestionRef* ref in self.prepopulatedQuestionRefs) {
        [result setValue:ref forKey:ref.referenceIdentifier];
    }
    return result;
}

- (NSDictionary*) questionDictByRefIdForSurvey:(NUSurvey*)survey {
    NSMutableDictionary* result = [[NSMutableDictionary new] autorelease];
    for (NSDictionary* section in [[survey deserialized] valueForKey:@"sections"]) {
        for (NSDictionary* questionOrGroup in [section valueForKey:@"questions_and_groups"]) {
            [result setValue:questionOrGroup forKey:[questionOrGroup valueForKey:@"reference_identifier"]];
            for (NSDictionary* groupQuestion in [section valueForKey:@"questions"]) {
                [result setValue:groupQuestion forKey:[groupQuestion valueForKey:@"reference_identifier"]];
            }
        }
    }
    return result;
}

- (void)dealloc {
    [_surveys release];
    [_responseSets release];
    [_participant release];
    [_prepopulatedQuestionRefs release];
    [super dealloc];
}

@end

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
