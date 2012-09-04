//
//  ResponseSetTest.m
//  NCSNavField
//
//  Created by John Dzak on 8/31/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "ResponseSetTest.h"
#import "ResponseSet.h"

@implementation ResponseSetTest

- (void)testSetPid {
    NSEntityDescription *e = [[self.model entitiesByName] objectForKey:@"ResponseSet"];
    ResponseSet *r = [[ResponseSet alloc] initWithEntity:e insertIntoManagedObjectContext:self.ctx];
    [r setValue:@"1d" forKey:@"pId"];
    NSError* error = nil;
    [self.ctx save:&error];
    STAssertNil(error, @"Should save successfully");
    STAssertEqualObjects([r valueForKey:@"pId"], @"1d", @"Wrong pId");    
}

- (void)testToDictWithPid {
    NSEntityDescription *e = [[self.model entitiesByName] objectForKey:@"ResponseSet"];
    ResponseSet *r = [[ResponseSet alloc] initWithEntity:e insertIntoManagedObjectContext:self.ctx];
    [r setValue:@"1d" forKey:@"pId"];
    STAssertEqualObjects([[r toDict] objectForKey:@"p_id"], @"1d", @"Wrong p_id");
}

- (void)testFromJsonWithPid {
    NSEntityDescription *e = [[self.model entitiesByName] objectForKey:@"ResponseSet"];
    ResponseSet *r = [[ResponseSet alloc] initWithEntity:e insertIntoManagedObjectContext:self.ctx];
    [r fromJson:@"{\"p_id\":\"1d\"}"];
    STAssertEqualObjects([r valueForKey:@"pId"], @"1d", @"Wrong pId");
}

@end
