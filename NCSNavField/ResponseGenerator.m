//
//  ResponseGenerator.m
//  NCSNavField
//
//  Created by John Dzak on 11/8/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "ResponseGenerator.h"
#import <NUSurveyor/NUSurvey.h>
#import "NUSurvey+Additions.h"
#import <MRCEnumerable/MRCEnumerable.h>
#import <NUSurveyor/NUResponse.h>
#import "NUResponse+Additions.h"
#import <NUSurveyor/UUID.h>

@implementation ResponseGenerator

@synthesize survey = _survey;
@synthesize context = _context;

- (id)initWithSurvey:(NUSurvey*)survey context:(NSDictionary*)context {
    if (self = [self init]) {
        self.survey = survey;
        self.context = context;
    }
    return self;
}

- (NSArray*)responses {
    NSArray* prepopulated = [self prepopulatedQuestions:self.survey];
    
    NSArray* filtered = [self selectQuestions:prepopulated referencedInContext:self.context];
    
    return [self buildAndPopulateQuestions:filtered withContext:self.context];
}

- (NSArray*)prepopulatedQuestions:(NUSurvey*)survey {
    NSMutableArray* result = [NSMutableArray new];
    
    NSDictionary* deserial = [self.survey deserialized];
    for (NSDictionary* section in [deserial valueForKey:@"sections"]) {
        for (NSDictionary* question in [section valueForKey:@"questions_and_groups"]) {
            NSString* refId = [self referenceIdentifierOfQuestion:question];
            if ([self parsePrepopulatedPostTextForReferenceIdentifier:refId]) {
                [result addObject:question];
            }
        }
    }
    
    return result;
}

- (NSArray*) selectQuestions:(NSArray*)questions referencedInContext:(NSDictionary*)context {
    return [questions select:^BOOL(id obj){
        NSDictionary* question = obj;
        NSString* refId = [self referenceIdentifierOfQuestion:question];
        NSString* parsed = [self parsePrepopulatedPostTextForReferenceIdentifier:refId];
        BOOL inContext = [[self.context allKeys] indexOfObject:parsed] != NSNotFound;
        return parsed && inContext;
    }];
}

- (NSArray*) buildAndPopulateQuestions:(NSArray*)questions withContext:(NSDictionary*)context{
    return [questions collect:^id(id obj){
        NSDictionary* question = obj;
        NSString* parsedRef = [self parsePrepopulatedPostTextForReferenceIdentifier:[self referenceIdentifierOfQuestion:question]];
        NSString* value = self.context[parsedRef] ? [NSString stringWithFormat:@"%@", self.context[parsedRef]] : nil;
        NSString* qUUID = [question valueForKey:@"uuid"];
        NSDictionary* answer = [self findAnswerFromAnswers:[question valueForKey:@"answers"] withReferenceIdentifier:value];
        if (!answer) {
            answer = [[question valueForKey:@"answers"] objectAtIndex:0];
        }
        NSString* aUUID = [answer valueForKey:@"uuid"];
        NUResponse* response = [NUResponse transient];
        [response setValue:[UUID generateUuidString] forKey:@"uuid"];
        [response setValue:qUUID forKey:@"question"];
        [response setValue:aUUID forKey:@"answer"];
        [response setValue:value forKey:@"value"];
        return response;
    }];

}

- (NSDictionary*)findAnswerFromAnswers:(NSArray*)answers withReferenceIdentifier:(NSString*)refId {
    NSDictionary* result = nil;
    
    for (NSDictionary* answer in answers) {
        if ([[self referenceIdentifierOfQuestion:answer] isEqualToString:refId]) {
            result = answer;
            break;
        }
    }
    return result;
}

- (NSString*) parsePrepopulatedPostTextForReferenceIdentifier:(NSString*)refId{
    NSString* result = nil;
    if (refId) {
        NSRange range = [refId rangeOfString:@"prepopulated_" options:(NSAnchoredSearch|NSCaseInsensitiveSearch)];
        if (range.location != NSNotFound) {
            result = [[refId stringByReplacingCharactersInRange:range withString:[NSString string]] lowercaseString];
        }
    }
    return result;
}

- (NSString*)referenceIdentifierOfQuestion:(NSDictionary*)question {
    return [[question valueForKey:@"reference_identifier"] lowercaseString];
}

@end
