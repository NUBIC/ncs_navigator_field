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
        _main = [main retain];
        _backup = [backup retain];
    }
    return self;
}

- (BOOL) perform {
    NSFileManager* fm = [NSFileManager defaultManager];
    BOOL success = false;
    if (self.main && self.backup) {
        success = [fm copyItemAtPath:self.main toPath:self.backup error:NULL];
    }
    return success;
}

@end
