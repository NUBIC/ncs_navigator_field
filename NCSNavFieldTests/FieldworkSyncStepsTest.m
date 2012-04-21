//
//  SyncStepsTest.m
//  NCSNavField
//
//  Created by John Dzak on 4/20/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "FieldworkSyncStepsTest.h"
#import "BackupFieldworkStep.h"

@implementation NSDate (Stub)

+ (id)date {
    NSDateFormatter* f = [[NSDateFormatter alloc] init];
    [f setDateFormat:@"yyyy'-'MM'-'dd' 'HH':'mm':'ss"];
    [f setTimeZone:[NSTimeZone localTimeZone]];
    return [f dateFromString:@"2012-04-20 16:01:59"];
}

@end

@implementation FieldworkSyncStepsTest

BackupFieldworkStep* bfs;

- (void) setUp {
    NSString *filePath = [self mainFieldworkPath];
    if (!filePath) {
        filePath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"main.sqlite"];
        NSData *data = [@"Test" dataUsingEncoding:NSUTF8StringEncoding];
        [data writeToFile:filePath atomically:YES];
        filePath = [self mainFieldworkPath];
    }
    STAssertNotNil(filePath, @"Path should exist");
    
    bfs = [BackupFieldworkStep new];
}

- (void) tearDown {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"sync-backup-20120420160159" ofType:@"sqlite"];
    NSFileManager* dfm = [NSFileManager defaultManager];
    [dfm removeItemAtPath:filePath error:NULL];
}

- (void)testBackupFieldworkFilename {
    STAssertEqualObjects([bfs backupFieldworkFilename], @"sync-backup-20120420160159.sqlite", @"Wrong backup filename");
}

- (void)testPerformBackup {
    [bfs perform];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"sync-backup-20120420160159" ofType:@"sqlite"];
    STAssertNotNil(filePath, @"Path should exist");
    STAssertTrue([bfs success], @"Should be successful");
}

- (void)testPerformBackupUnsuccessfull {
    [bfs perform];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"sync-backup-20120420160159" ofType:@"sqlite"];
    NSError* error;
    [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
    STAssertNil([[NSBundle mainBundle] pathForResource:@"sync-backup-20120420160159" ofType:@"sqlite"] , @"Path should not exist");
    STAssertFalse([bfs success], @"Should be unsuccessful");
}

- (NSString*) mainFieldworkPath {
    return [[NSBundle mainBundle] pathForResource:@"main" ofType:@"sqlite"];
}


@end
