//
//  BackupFieldworkStep.m
//  NCSNavField
//
//  Created by John Dzak on 4/20/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "ApplicationPersistentStore.h"
#import "ApplicationPersistentStoreBackup.h"
#import "ApplicationPersistentStoreBackupOperation.h"
/*
 Singleton utilized to handle the backup of the sqlite db instance. Any time we want to take the current
 sqlite db instance and copy it in the file system for safe keeping, we will call 'backup' on this singleton.
 If we want to remove the currently utilized db, we can call remove here as well.
 */
@interface ApplicationPersistentStore (Private)
-(id)init;
@end

@implementation ApplicationPersistentStore

static ApplicationPersistentStore* instance;

+ (ApplicationPersistentStore*) instance {
    if (!instance) {
        instance = [[ApplicationPersistentStore alloc] init];
    }
    return instance;
}
//This is the entry method to back up the database as an extra level of security just in case.
- (ApplicationPersistentStoreBackup*)backup {
    ApplicationPersistentStoreBackup* backup = [ApplicationPersistentStoreBackup new];
    ApplicationPersistentStoreBackupOperation* op = 
        [[ApplicationPersistentStoreBackupOperation alloc] initWithMainPersistentStorePath:[self path] andBackupStorePath:[backup path]];
    
    if ([op perform]) {
        return backup;
    }
    return NULL;
}

- (void) remove {
    RKObjectManager* objectManager = [RKObjectManager sharedManager];
    RKManagedObjectStore* objectStore = objectManager.objectStore;
    [objectStore deletePersistentStore];
}

- (NSString*)path {
    RKObjectManager* objectManager = [RKObjectManager sharedManager];
    RKManagedObjectStore* objectStore = objectManager.objectStore;
    return objectStore.pathToStoreFile;
}

@end
