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
	
    // Set-up code here.
	self.bundle = [NSBundle bundleWithIdentifier:@"nubic.NCSNavFieldTest"];
	self.model = [NSManagedObjectModel mergedModelFromBundles:[NSBundle allBundles]];
	self.coord = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.model];
	self.store = [self.coord addPersistentStoreWithType: NSInMemoryStoreType
                                          configuration: nil
                                                    URL: nil
                                                options: nil 
                                                  error: NULL];
	self.ctx = [[NSManagedObjectContext alloc] init];
	[self.ctx setPersistentStoreCoordinator: self.coord];
}

- (void)tearDown
{
    // Tear-down code here.
	self.ctx = nil;
	NSError *error = nil;
	STAssertTrue([self.coord removePersistentStore: self.store error: &error], 
                 @"couldn't remove persistent store: %@", error);
	self.store = nil;
	self.coord = nil;
	self.model = nil;
    self.bundle = nil;
	
    [super tearDown];
}

- (void)testThatEnvironmentWorks {
	STAssertNotNil(self.store, @"no persistent store");
}

@end
