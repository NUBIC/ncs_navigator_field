//
//  NUQuestion.m
//  NCSNavField
//
//  Created by John Dzak on 12/14/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "NUQuestion.h"
#import "NUAnswer.h"

@implementation NUQuestion

- (id)initWithDictionary:(NSDictionary*)dict {
    self = [self init];
    if (self) {
        self.uuid = [dict valueForKey:@"uuid"];
        self.text = [dict valueForKey:@"text"];
        self.referenceIdentifier = [dict valueForKey:@"reference_identifier"];
        NSMutableArray* answers = [NSMutableArray new];
        for (NSDictionary* aDict in [dict objectForKey:@"answers"]) {
            NUAnswer* a = [[NUAnswer alloc] initWithDictionary:aDict];
            [answers addObject:a];
        }
        self.answers = answers;
    }
    return self;
}

@end
