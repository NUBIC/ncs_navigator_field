//
//  NUQuestionGroup.m
//  NCSNavField
//
//  Created by John Dzak on 1/17/13.
//  Copyright (c) 2013 Northwestern University. All rights reserved.
//

#import "NUQuestionGroup.h"
#import "NUQuestion.h"

@implementation NUQuestionGroup

- (id)initWithDictionary:(NSDictionary*)questionGroupDict {
    self = [self init];
    
    NSMutableArray* questions = [NSMutableArray new];
    for (NSDictionary* qDict in [questionGroupDict objectForKey:@"questions"]) {
        [questions addObject:[NUQuestion transientWithDictionary:qDict]];
    }
    self.questions = questions;
    
    return self;
}

+ (BOOL)isQuestionGroupDict:(NSDictionary*)dict {
    return [dict objectForKey:@"questions"] != NULL && [dict objectForKey:@"questions"] != [NSNull null];
}

@end
