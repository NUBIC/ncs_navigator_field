//
//  NUQuestion.m
//  NCSNavField
//
//  Created by John Dzak on 12/14/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "NUQuestion.h"

@implementation NUQuestion

- (id)initWithQuestionDictionary:(NSDictionary*)dQuestion {
    self = [self init];
    if (self) {
        self.questionDictionary = dQuestion;
    }
    return self;
}

- (NSString*)text {
    return [_questionDictionary valueForKey:@"text"];
}

@end
