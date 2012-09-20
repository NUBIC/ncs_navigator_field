//
//  NUSurvey+Additions.m
//  NCSNavField
//
//  Created by John Dzak on 9/19/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "NUSurvey+Additions.h"
#import <JSONKit.h>

@implementation NUSurvey (Additions)

- (NSString*)title {
    return [[self.jsonString objectFromJSONString] objectForKey:@"title"];
}

- (NSString*)uuid {
    return [[self.jsonString objectFromJSONString] objectForKey:@"uuid"];
}
@end
