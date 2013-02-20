//
//  ResponseSetMustacheContext.m
//  NCSNavField
//
//  Created by John Dzak on 2/20/13.
//  Copyright (c) 2013 Northwestern University. All rights reserved.
//

#import "ResponseSetMustacheContext.h"
#import "ResponseSet.h"

@implementation ResponseSetMustacheContext

- (id)initWithResponseSet:(ResponseSet*)rs {
    self = [self init];
    if (self) {
        // Do stuff
    }
    return self;
}

- (NSDictionary*)toDictionary {
    return @{};
}

@end
