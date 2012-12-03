//
//  DispositionCode.m
//  NCSNavField
//
//  Created by Sam Hicks on 11/27/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "DispositionCode.h"
#import "PickerOption.h"

@implementation DispositionCode

@dynamic categoryCode;
@dynamic disposition;
@dynamic finalCategory;
@dynamic finalCode;
@dynamic interimCode;
@dynamic subCategory;

+ (NSArray*)allPickerOptions {
    return [[[DispositionCode allObjects] collect:^id(id obj) {
        DispositionCode* c = obj;
        return [[PickerOption alloc] initWithText:[NSString stringWithFormat:@"%@ - %@ - %@", c.categoryCode, c.finalCategory, c.disposition] value:c.finalCode];
    }] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        PickerOption* o1 = obj1;
        PickerOption* o2 = obj2;
        return [o1.text caseInsensitiveCompare:o2.text];
    }];
}

+ (NSArray*)allDispositionCategories {
    NSMutableArray* results = [NSMutableArray new];
    for (DispositionCode* c in [DispositionCode allObjects]) {
        NSArray* temp = [NSArray arrayWithObjects:c.categoryCode, nil];
        if (![results containsObject:temp]) {
            [results addObject:temp];
        }
    }
    return results;
}

+ (NSArray*)allPickerOptionsForDispositionCategories {
    return [[[self allDispositionCategories] collect:^id(id obj){
        NSArray* category = obj;
        return [[PickerOption alloc] initWithText:[NSString stringWithFormat:@"%@", [category objectAtIndex:0]] value:[category objectAtIndex:0]];
    }] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
        PickerOption* o1 = obj1;
        PickerOption* o2 = obj2;
        return [o1.text caseInsensitiveCompare:o2.text];
    }];
}

@end
