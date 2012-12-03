//
//  ResponseSet.m
//  NCSNavField
//
//  Created by John Dzak on 9/4/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "ResponseSet.h"
#import "JSONKit.h"

@implementation ResponseSet

- (NSDictionary*) toDict {
    NSMutableDictionary* d = [NSMutableDictionary dictionaryWithDictionary:[super toDict]];
    [d setValue:[self valueForKey:@"pId"] forKey:@"p_id"];
    return d;
}

- (void) fromJson:(NSString *)jsonString {
    [super fromJson:jsonString];
    NSDictionary *jsonData = [jsonString objectFromJSONString];
    [self setValue:[jsonData valueForKey:@"p_id"] forKey:@"pId"];
}

@end
