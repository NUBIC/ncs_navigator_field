//
//  NUAnswer.m
//  NCSNavField
//
//  Created by John Dzak on 12/14/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "NUAnswer.h"

@implementation NUAnswer

- (id)initWithDictionary:(NSDictionary*)dict {
    self = [self init];
    if (self) {
        self.uuid = [dict valueForKey:@"uuid"];
        self.referenceIdentifier = [dict valueForKey:@"reference_identifier"];
    }
    return self;
}

@end
