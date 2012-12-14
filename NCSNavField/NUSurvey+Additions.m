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

// TODO: We should move this to surveyor
@implementation NUSurvey (Additions)

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
        [sections addObject:[[NUSection alloc] initWithSectionDictionary:dSection]];
    }
    return sections;
}

@end
