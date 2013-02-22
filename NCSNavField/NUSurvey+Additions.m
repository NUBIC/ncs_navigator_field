//
//  NUSurvey+Additions.m
//  NCSNavField
//
//  Created by John Dzak on 9/19/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import <NUSurvey.h>
#import "NUSurvey+Additions.h"
#import <JSONKit.h>
#import "NUSection.h"
#import <MRCEnumerable/MRCEnumerable.h>
#import "InstrumentTemplate.h"
#import <RestKit/RestKit.h>

// TODO: We should move this to surveyor
@implementation NUSurvey (Additions)

- (id)initWithJson:(NSString*)json {
    self = [self init];
    if (self) {
        self.jsonString = json;
    }
    return self;
}

- (NSString*)title {
    return [[self deserialized] objectForKey:@"title"];
}

- (NSString*)uuid {
    return [[self deserialized] objectForKey:@"uuid"];
}

- (NSDictionary*)deserialized {
    return [self.jsonString objectFromJSONString];
}

- (NSArray*)sections {
    NSMutableArray* sections = [NSMutableArray new];
    for (NSDictionary* dSection in [[self deserialized] objectForKey:@"sections"]) {
        [sections addObject:[[NUSection alloc] initWithDictionary:dSection]];
    }
    return sections;
}

- (NSArray*)questionsForAllSections {
    NSMutableArray* questions = [NSMutableArray new];
    for (NUSection* s in [self sections]) {
        [questions addObjectsFromArray:s.questions];
    }
    return questions;
}

- (InstrumentTemplate*)instrumentTemplate {
    return [InstrumentTemplate findFirstByAttribute:@"instrumentTemplateId" withValue:[self uuid]];
}

+ (NUSurvey*)findByUUUID:(NSString*)uuid {
    InstrumentTemplate* t = [InstrumentTemplate findFirstByAttribute:@"instrumentTemplateId" withValue:uuid];
    return t ? [[NUSurvey alloc] initWithJson:t.representation] : nil;
}

@end
