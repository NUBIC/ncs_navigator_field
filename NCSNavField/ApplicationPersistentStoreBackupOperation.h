//
//  ApplicationPersistentStoreBackupOperation.h
//  NCSNavField
//
//  Created by John Dzak on 4/30/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApplicationPersistentStoreBackupOperation : NSObject {
    NSString* _main;
    NSString* _backup;
}

@property(nonatomic,strong) NSString* main;
@property(nonatomic,strong) NSString* backup;

-(id)initWithMainPersistentStorePath:(NSString*)main andBackupStorePath:(NSString*)backupPath;

- (BOOL) perform;

@end