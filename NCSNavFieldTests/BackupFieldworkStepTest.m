//
//  SyncStepsTest.m
//  NCSNavField
//
//  Created by John Dzak on 4/20/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "BackupFieldworkStepTest.h"
#import "ApplicationPersistentStore.h"
#import "ApplicationPersistentStoreBackup.h"

@implementation NSDate (Stub)

+ (id)date {
    NSDateFormatter* f = [[NSDateFormatter alloc] init];
    [f setDateFormat:@"yyyy'-'MM'-'dd' 'HH':'mm':'ss"];
    [f setTimeZone:[NSTimeZone localTimeZone]];
    return [f dateFromString:@"2012-04-20 16:01:59"];
}

@end

@implementation BackupFieldworkStepTest

ApplicationPersistentStore* store;
ApplicationPersistentStoreBackup* backup;

- (void) setUp {
    NSFileManager* fm = [NSFileManager defaultManager];
    [fm removeItemAtPath:[self backupFieldworkPath] error:NULL];

    NSString *filePath = [self mainFieldworkPath];
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        [self touch:filePath];
    }
    STAssertTrue([[NSFileManager defaultManager] fileExistsAtPath:[self mainFieldworkPath]], @"main.sqlite should exist");
    
    store = [ApplicationPersistentStore instance];
    backup = [store backup];
}

- (void) tearDown {
    NSFileManager* dfm = [NSFileManager defaultManager];
    [dfm removeItemAtPath:[self backupFieldworkPath] error:NULL];
    [dfm removeItemAtPath:[self testFilePath] error:NULL];
}

- (void)testGenerateBackupFilename {
    ApplicationPersistentStoreBackup* store = 
        [ApplicationPersistentStoreBackup new];
    STAssertEqualObjects([store generateBackupFilename], @"sync-backup-20120420160159.sqlite", @"Wrong backup filename");
}

- (void)testBackup {
    STAssertTrue([[NSFileManager defaultManager] fileExistsAtPath:[backup path]], @"Should backup successfully");
}

- (void)testRemove {
    STAssertTrue([[NSFileManager defaultManager] fileExistsAtPath:[backup path]], @"Should exist");
    [backup remove];
    STAssertFalse([[NSFileManager defaultManager] fileExistsAtPath:[backup path]], @"Should not exist");
}

- (void)testRemoveAll {
    STAssertTrue([[NSFileManager defaultManager] fileExistsAtPath:[backup path]], @"Should exist");
    [ApplicationPersistentStoreBackup removeAll];
    STAssertFalse([[NSFileManager defaultManager] fileExistsAtPath:[backup path]], @"Should not exist");
}

- (void)testRemoveAllOnlyRemovesBackups {
    NSString* tf = [self testFilePath];
    [self touch:tf];
    STAssertTrue([[NSFileManager defaultManager] fileExistsAtPath:tf], @"Should exist");
    [ApplicationPersistentStoreBackup removeAll];
    STAssertTrue([[NSFileManager defaultManager] fileExistsAtPath:tf], @"Should exist");
}

#pragma mark - Helper Methods

- (NSString*) mainFieldworkPath {
    return [[ApplicationPersistentStore new] path];
}

- (NSString *)backupFieldworkPath {
    return [[ApplicationPersistentStoreBackup new] path];
}

- (NSString*)testFilePath {
    return [[[backup path] stringByDeletingLastPathComponent] stringByAppendingPathComponent:@"testfile"];
}

- (void)touch:(NSString*)path {
    [[NSData data] writeToFile:path options:NSDataWritingAtomic error:nil];
}

@end
