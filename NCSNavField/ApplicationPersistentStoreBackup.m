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
//
//- (id)initWithMainStorePath:(NSString*)main {
//    self = [super init];
//    if (self) {
//        _mainPersistentStore = [main retain];
//        _name = [[self generateBackupFilename] retain];
//        [NSFileManager defaultManager];
//        if (_name && main) {
//            <#statements#>
//        }
//        BOOL result = [self copy];
//        if (!result) { return NULL; }
//    }
//    return self;
//}
//
//- (BOOL)copy {
//    NSString* main = [ApplicationPersistentStore path];
//    NSString* backup = self.name;
//    
//    if (main && backup) {
//        NSFileManager* fm = [NSFileManager defaultManager];
//        return [fm copyItemAtPath:main toPath:backup error:NULL];
//    }
//    return FALSE;
//}

- (void)remove {
    NSString* backup = [self path];
    if (backup) {
        NSFileManager* fm = [NSFileManager defaultManager];
        [fm removeItemAtPath:[self path] error:NULL];
    }
}

- (NSString*)generateBackupFilename {
    NSDateFormatter *timeFmt = [[NSDateFormatter alloc] init];
    [timeFmt setDateFormat:@"yyyyMMddHHmmss"];
    [timeFmt setTimeZone:[NSTimeZone localTimeZone]];
    return [NSString stringWithFormat:@"sync-backup-%@.sqlite", [timeFmt stringFromDate:[NSDate date]]]; 
}

- (NSString*)path {
    return [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:self.name];
}

@end
