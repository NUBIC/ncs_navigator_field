//
//  BackupFieldworkStep.m
//  NCSNavField
//
//  Created by John Dzak on 4/20/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "BackupFieldworkStep.h"

@implementation BackupFieldworkStep

@synthesize fm = _fm;
@synthesize performedAt = _performedAt;

- (id)init {
    self = [super init];
    if (self) {
        _fm = [[NSFileManager defaultManager] retain];
    }
    return self;
}

- (void)perform {
    if (!self.performedAt) {
        self.performedAt = [NSDate date];
    }
    
    NSString* main = [self mainFieldworkPath];
    NSString* backup = [self backupFieldworkPath];

    if (main && backup) {
        BOOL result = [self.fm copyItemAtPath:main toPath:backup error:NULL];
        
        if (!result) {
            [self.fm removeItemAtPath:backup error:NULL];
        }
    }
}

- (void)rollback {
    NSString* backup = [self backupFieldworkPath];
    if (backup) {
        [self.fm removeItemAtPath:[self backupFieldworkPath] error:NULL];
    }
}

- (BOOL)success {
    NSString* backup = [self backupFieldworkPath];
    return [self.fm fileExistsAtPath:backup];
}

- (NSString*)backupFieldworkFilename {
    NSString* name = NULL;
    if (self.performedAt) {
        NSDateFormatter *timeFmt = [[NSDateFormatter alloc] init];
        [timeFmt setDateFormat:@"yyyyMMddHHmmss"];
        [timeFmt setTimeZone:[NSTimeZone localTimeZone]];
        name = [NSString stringWithFormat:@"sync-backup-%@.sqlite", [timeFmt stringFromDate:[NSDate date]]]; 
    }
    return name;
}

- (NSString*)mainFieldworkPath {
    return [[NSBundle mainBundle] pathForResource:@"main" ofType:@"sqlite"];
}

- (NSString*)backupFieldworkPath {
    return [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:[self backupFieldworkFilename]];
}

@end
