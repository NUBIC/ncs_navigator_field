//
//  NUDatabaseTest.m
//  
//
//  Created by John Dzak on 3/27/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "DatabaseTest.h"

@implementation DatabaseTest

@synthesize bundle = _bundle, coord = _coord, ctx = _ctx, model = _model, surveyorModel = _surveyorModel, store = _store;

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [[RKObjectManager sharedManager].objectStore deletePersistentStore];
	
    [super tearDown];
}

- (void)testThatEnvironmentWorks {
	STAssertNotNil([RKObjectManager sharedManager].objectStore, @"no persistent store");
}

@end
