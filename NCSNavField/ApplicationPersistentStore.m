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

@implementation ApplicationPersistentStore

static ApplicationPersistentStore* instance;

+ (ApplicationPersistentStore*) instance {
    if (!instance) {
        instance = [[ApplicationPersistentStore alloc] init];
    }
    return instance;
}

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
    [objectStore deletePersistantStore];
}

- (NSString*)path {
    RKObjectManager* objectManager = [RKObjectManager sharedManager];
    RKManagedObjectStore* objectStore = objectManager.objectStore;
    return objectStore.pathToStoreFile;
}

@end
