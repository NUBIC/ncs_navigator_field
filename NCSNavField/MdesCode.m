//
//  MdesCode.m
//  NCSNavField
//
//  Created by Sam Hicks on 11/19/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "MdesCode.h"
#import "PickerOption.h"
#import <MRCEnumerable/MRCEnumerable.h>

@implementation MdesCode

static const NSInteger MISSING_IN_ERROR = -4;

@dynamic displayText, listName, localCode;

+(NSArray*)retrieveAllObjectsForListName:(NSString*)listName
{
    NSLog(@"Retrieving List Name: %@",listName);

    NSArray* results = [MdesCode findByAttribute:@"listName" withValue:listName andOrderBy:@"localCode" ascending:NO];

    [results reject:^BOOL(id obj) {
        MdesCode* c = obj;
        return [c.localCode isEqualToNumber:[NSNumber numberWithInt:MISSING_IN_ERROR]];
    }];
    
    return [self convertToPickerOptions:results];
}

+ (NSArray*)convertToPickerOptions:(NSArray*)mdesCodes {
    return [mdesCodes collect:^id(id obj) {
        MdesCode* c = obj;
        return [[PickerOption alloc] initWithText:c.displayText value:c.localCode];
    }];
}

@end
