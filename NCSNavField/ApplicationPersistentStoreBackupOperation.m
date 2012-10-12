//
//  ApplicationPersistentStoreBackupOperation.m
//  NCSNavField
//
//  Created by John Dzak on 4/30/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "ApplicationPersistentStoreBackupOperation.h"

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
