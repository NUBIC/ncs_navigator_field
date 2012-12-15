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

@synthesize title = _title;
@synthesize questions = _questions;

- (id)initWithDictionary:(NSDictionary*)dict {
    self = [self init];
    if (self) {
        self.title = [dict valueForKey:@"title"];
        
        NSMutableArray* questions = [NSMutableArray new];
        for (NSDictionary* qDict in [dict objectForKey:@"questions_and_groups"]) {
            [questions addObject:[[NUQuestion alloc] initWithDictionary:qDict]];
        }
        self.questions = questions;
    }
    return self;
}

@end
