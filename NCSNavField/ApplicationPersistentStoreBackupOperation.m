//
//  ApplicationPersistentStoreBackupOperation.m
//  NCSNavField
//
//  Created by John Dzak on 4/30/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "ApplicationPersistentStoreBackupOperation.h"
/*
 The main class we use to create the backup of the current sqlite instance.
 Called from ApplicationPersistentStore to take the current object store (sqlite db)
 and back it up to the device by *copying* it.
 */
@implementation ApplicationPersistentStoreBackupOperation

@synthesize main = _main;
@synthesize backup = _backup;

-(id)initWithMainPersistentStorePath:(NSString*)main andBackupStorePath:(NSString*)backup {
    self = [super init];
    
    if (self) {
        _main = main;
        _backup = backup;
    }
    return self;
}
//Copy the currently used persistent sqlite db to the backup loaction. 
- (BOOL) perform {
    BOOL success = false;
    if (self.main && self.backup) {
        NSFileManager* fm = [NSFileManager defaultManager];
        NSError* error = nil;
        success = [fm copyItemAtPath:self.main toPath:self.backup error:&error];
        if (error) {
            NCSLog(@"Backup failed: %@", error);
        }
    }
    return success;
}

@end
