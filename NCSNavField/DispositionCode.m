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


+(NSArray*)pickerOptionsByCategoryCode:(NSString*)categoryCode {
    NSMutableArray *mutOptions = [NSMutableArray new];
    NSDictionary* categoriesByCode = [[MdesCode findByAttribute:@"listName" withValue:@"EVENT_DSPSTN_CAT_CL1"] inject:[NSMutableDictionary new] :^id(id accumObj, id obj){
        NSMutableDictionary* accum = accumObj;
        MdesCode* c = obj;
        [accum setObject:c.displayText forKey:c.localCode];
        return accum;
    }];
    NSArray *arr = [[DispositionCode allObjects] select:^BOOL(id obj) {
        DispositionCode* c = obj;
        return ([[categoriesByCode objectForKey:c.categoryCode] isEqualToString:categoryCode]);
            //return [[PickerOption alloc] initWithText:[NSString stringWithFormat:@"%@ - %@",c.finalCategory,c.disposition] value:c.finalCode];
    }];
    for(DispositionCode *c in arr) {
        [mutOptions addObject:[[PickerOption alloc] initWithText:[NSString stringWithFormat:@"%@ - %@",c.finalCategory,c.disposition] value:c.interimCode]];
    }
    return [mutOptions sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            PickerOption* o1 = obj1;
            PickerOption* o2 = obj2;
            return [o1.text caseInsensitiveCompare:o2.text];
        }];
}

+ (NSArray*)allPickerOptions {
    NSDictionary* categoriesByCode = [[MdesCode findByAttribute:@"listName" withValue:@"EVENT_DSPSTN_CAT_CL1"] inject:[NSMutableDictionary new] :^id(id accumObj, id obj){
        NSMutableDictionary* accum = accumObj;
        MdesCode* c = obj;

        [accum setObject:c.displayText forKey:c.localCode];
        return accum;
    }];
    return [[[DispositionCode allObjects] collect:^id(id obj) {
        DispositionCode* c = obj;
        return [[PickerOption alloc] initWithText:[NSString stringWithFormat:@"%@ - %@ - %@", [categoriesByCode objectForKey:c.categoryCode], c.finalCategory, c.disposition] value:c.interimCode];
    }] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        PickerOption* o1 = obj1;
        PickerOption* o2 = obj2;
        return [o1.text caseInsensitiveCompare:o2.text];
    }];
}

@end
