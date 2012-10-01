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

// TODO: We should move this to surveyor
@implementation NUSurvey (Additions)

- (NSString*)title {
    return [[self.jsonString objectFromJSONString] objectForKey:@"title"];
}

- (NSString*)uuid {
    return [[self.jsonString objectFromJSONString] objectForKey:@"uuid"];
}

- (NSDictionary*)deserialized {
    return [self.jsonString objectFromJSONString];
}
@end
