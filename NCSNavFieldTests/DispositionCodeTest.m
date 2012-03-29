//
//  DispositionCodeTest.m
//  NCSNavField
//
//  Created by John Dzak on 2/15/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "DispositionCodeTest.h"
#import "DispositionCode.h"

@implementation DispositionCodeTest

- (void)testPickerOptionsForContactTypeIdInPerson
{
    NSArray* codes = [DispositionCode pickerOptionsForContactTypeId:[NSNumber numberWithInteger:1]];
    STAssertEquals(45U, [codes count], @"Wrong number of disposition codes");
}

- (void)testPickerOptionsForContactTypeIdTelephone
{
    NSArray* codes = [DispositionCode pickerOptionsForContactTypeId:[NSNumber numberWithInteger:3]];
    STAssertEquals(67U, [codes count], @"Wrong number of disposition codes");
}

@end
