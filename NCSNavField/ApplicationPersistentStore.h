//
//  BackupFieldworkSetStep.h
//  NCSNavField
//
//  Created by John Dzak on 4/20/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ApplicationPersistentStoreBackup;

@interface ApplicationPersistentStore : NSObject

+ (ApplicationPersistentStore*) instance;

- (ApplicationPersistentStoreBackup*)backup;

- (void) remove;

- (NSString*)path;

@end
