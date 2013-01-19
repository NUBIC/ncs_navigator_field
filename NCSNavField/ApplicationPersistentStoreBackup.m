//
//  ApplicationPersistentStoreBackup.m
//  NCSNavField
//
//  Created by John Dzak on 4/30/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "ApplicationPersistentStoreBackup.h"
//Class that contains methods to create a sqlite database
//backup as a fail-safe. This class contains the methods to
//remove the files and constructing the name and so forth. 
@implementation ApplicationPersistentStoreBackup

@synthesize name = _name;

-(id) init {
    self = [super init];
    if (self) {
        _name = [self generateBackupFilename];
    }
    return self;
}
//Remove the sqlite db corresponding to this particular instance.
- (void)remove {
    NSString* backup = [self path];
    if (backup) {
        NSFileManager* fm = [NSFileManager defaultManager];
        [fm removeItemAtPath:[self path] error:NULL];
    }
}
//We need a unique file name for the backup sqlite db.
- (NSString*)generateBackupFilename {
    NSDateFormatter *timeFmt = [[NSDateFormatter alloc] init];
    [timeFmt setDateFormat:@"yyyyMMddHHmmss"];
    [timeFmt setTimeZone:[NSTimeZone localTimeZone]];
    return [NSString stringWithFormat:@"%@-%@.sqlite", [ApplicationPersistentStoreBackup prefix], [timeFmt stringFromDate:[NSDate date]]];
}

+ (NSString*) prefix {
    return @"sync-backup";
}
//Get the path to where the sqlite db associated with this instance is stored. 
- (NSString*)path {
    return [[RKDirectory applicationDataDirectory] stringByAppendingPathComponent:self.name];
}
//Remove all the sqlite db backup files that exist on device.
+ (void)removeAll {
    NSString* path = [RKDirectory applicationDataDirectory];
    NSFileManager* fm = [[NSFileManager alloc] init];
    NSDirectoryEnumerator* en = [fm enumeratorAtPath:path];
    NSError* err = nil;
    BOOL res;
    
    NSString* file;
    while (file = [en nextObject]) {
        BOOL isBackup = [file rangeOfString:[ApplicationPersistentStoreBackup prefix] options:(NSCaseInsensitiveSearch | NSAnchoredSearch)].location != NSNotFound;
        if (isBackup) {
            res = [fm removeItemAtPath:[path stringByAppendingPathComponent:file] error:&err];
        }
        if (!res && err) {
            NSLog(@"Could not remove backup: %@", err);
        }
    }
}


@end
