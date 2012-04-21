//
//  BackupFieldworkSetStep.m
//  NCSNavField
//
//  Created by John Dzak on 4/20/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "BackupFieldworkStep.h"

@implementation BackupFieldworkStep

@synthesize fm = _fm;

- (id) init {
    self = [super init];
    if (self) {
        _fm = [[NSFileManager defaultManager] retain];
    }
    return self;
}

- (void) perform {
    NSString* main = [self mainFieldworkPath];
    NSString* backup = [self backupFieldworkPath];

    if (main && backup) {
        BOOL result = [self.fm copyItemAtPath:main toPath:backup error:NULL];
        
        if (!result) {
            [self.fm removeItemAtPath:backup error:NULL];
        }
    }
}

- (BOOL) success {
    NSString* backup = [self backupFieldworkPath];
    return [self.fm fileExistsAtPath:backup];
}

- (NSString*) backupFieldworkFilename {
    NSDateFormatter *timeFmt = [[NSDateFormatter alloc] init];
    [timeFmt setDateFormat:@"yyyyMMddHHmmss"];
    [timeFmt setTimeZone:[NSTimeZone localTimeZone]];
    return [NSString stringWithFormat:@"sync-backup-%@.sqlite", [timeFmt stringFromDate:[NSDate date]]];
}

- (NSString*) mainFieldworkPath {
    return [[NSBundle mainBundle] pathForResource:@"main" ofType:@"sqlite"];
}

- (NSString*) backupFieldworkPath {
    return [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:[self backupFieldworkFilename]];
}

@end
