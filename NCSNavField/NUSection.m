//
//  NUSection.m
//  NCSNavField
//
//  Created by John Dzak on 12/14/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "NUSection.h"
#import "NUQuestion.h"

@implementation NUSection

@synthesize sectionDictionary = _sectionDictionary;

- (id)initWithSectionDictionary:(NSDictionary*)sectionDict {
    self = [self init];
    if (self) {
        self.sectionDictionary = sectionDict;
    }
    return self;
}

- (NSString*)title {
    return [self.sectionDictionary valueForKey:@"title"];
}

- (NSArray*)questions {
    NSMutableArray* questions = [NSMutableArray new];
    for (NSDictionary* dQuestion in [self.sectionDictionary objectForKey:@"questions_and_groups"]) {
        NUQuestion* q = [[NUQuestion alloc] initWithQuestionDictionary:dQuestion];
        [questions addObject:q];
    }
    return questions;
}

@end
