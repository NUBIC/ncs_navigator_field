//
//  ResponseSet.m
//  NCSNavField
//
//  Created by John Dzak on 9/4/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "ResponseSet.h"
#import "JSONKit.h"
#import "NUSurvey+Additions.h"
#import <RestKit/RestKit.h>

@implementation ResponseSet

- (NSDictionary*) toDict {
    NSMutableDictionary* d = [NSMutableDictionary dictionaryWithDictionary:[super toDict]];
    [d setValue:[self valueForKey:@"pId"] forKey:@"p_id"];
    [d setValue:[self valueForKey:@"personId"] forKey:@"person_id"];
    return d;
}

- (void) fromJson:(NSString *)jsonString {
    [super fromJson:jsonString];
    NSDictionary *jsonData = [jsonString objectFromJSONString];
    [self setValue:[jsonData valueForKey:@"p_id"] forKey:@"pId"];
    [self setValue:[jsonData valueForKey:@"person_id"] forKey:@"personId"];
}

+ (ResponseSet*)createResponseSetWithSurvey:(NUSurvey*)survey pId:(NSString*)pId personId:(NSString*)personId {
    ResponseSet* rs = [ResponseSet newResponseSetForSurvey:survey.deserialized withModel:[RKObjectManager sharedManager].objectStore.managedObjectModel inContext:[RKObjectManager sharedManager].objectStore.managedObjectContextForCurrentThread];
    [rs setValue:pId forKey:@"pId"];
    [rs setValue:personId forKey:@"personId"];
    [rs setValue:survey.uuid forKey:@"survey"];
    return rs;
}

@end
