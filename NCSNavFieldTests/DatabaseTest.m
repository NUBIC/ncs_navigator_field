//
//  NUDatabaseTest.m
//  
//
//  Created by John Dzak on 3/27/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "DatabaseTest.h"

@implementation DatabaseTest

- (void)setUp
{
    [super setUp];
    
    [[RKObjectManager sharedManager].objectStore deletePersistentStore];
    [[NSManagedObjectContext contextForCurrentThread] reset];
}

- (NSManagedObjectContext*)managedObjectContext {
    return [NSManagedObjectContext contextForCurrentThread];
}

- (void)tearDown
{   
    [super tearDown];
}

- (void)testThatEnvironmentWorks {
	STAssertNotNil([RKObjectManager sharedManager].objectStore, @"no persistent store");
}

@end
