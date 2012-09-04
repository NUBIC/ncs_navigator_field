//
//  NUResponseSetTest.m
//  NCSNavField
//
//  Created by John Dzak on 8/31/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "NUResponseSetTest.h"
#import "NUResponseSet.h"

@implementation NUResponseSetTest

- (void)testToDictWithPid {
    NSEntityDescription *e = [[self.model entitiesByName] objectForKey:@"ResponseSet"];
    NUResponseSet *r = [[NUResponseSet alloc] initWithEntity:e insertIntoManagedObjectContext:self.ctx];
    [r setValue:@"1d" forKey:@"pId"];
    NSError* error = nil;
    [self.ctx save:&error];
    STAssertNil(error, @"Should save successfully");
    STAssertEqualObjects([r valueForKey:@"pId"], @"1d", @"Wrong pId");
}

@end
