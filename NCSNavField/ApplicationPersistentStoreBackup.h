//
//  ApplicationPersistentStoreBackup.h
//  NCSNavField
//
//  Created by John Dzak on 4/30/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApplicationPersistentStoreBackup : NSObject {
    NSString* _name;
}

@property(nonatomic,retain) NSString* name;

- (void)remove;

- (NSString*)generateBackupFilename;

- (NSString*)path;

+ (void)removeAll;

@end
