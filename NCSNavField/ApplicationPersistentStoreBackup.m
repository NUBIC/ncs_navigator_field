//
//  ApplicationPersistentStoreBackup.m
//  NCSNavField
//
//  Created by John Dzak on 4/30/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "ApplicationPersistentStoreBackup.h"

@implementation ApplicationPersistentStoreBackup

@synthesize name = _name;

-(id) init {
    self = [super init];
    if (self) {
        _name = [[self generateBackupFilename] retain];
    }
    return self;
}

- (void)remove {
    NSString* backup = [self path];
    if (backup) {
        NSFileManager* fm = [NSFileManager defaultManager];
        [fm removeItemAtPath:[self path] error:NULL];
    }
}

- (NSString*)generateBackupFilename {
    NSDateFormatter *timeFmt = [[[NSDateFormatter alloc] init] autorelease];
    [timeFmt setDateFormat:@"yyyyMMddHHmmss"];
    [timeFmt setTimeZone:[NSTimeZone localTimeZone]];
    return [NSString stringWithFormat:@"sync-backup-%@.sqlite", [timeFmt stringFromDate:[NSDate date]]]; 
}

- (NSString*)path {
    return [[RKDirectory applicationDataDirectory] stringByAppendingPathComponent:self.name];
}

- (void)dealloc {
    [_name release];
    [super dealloc];
}

@end
