//
//  BackupFieldworkSetStep.h
//  NCSNavField
//
//  Created by John Dzak on 4/20/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BackupFieldworkStep : NSObject {
    NSFileManager* _fm;
}

@property(nonatomic,retain) NSFileManager* fm;

- (void) perform;

- (BOOL) success;

- (NSString*) backupFieldworkPath;

- (NSString*) mainFieldworkPath;

- (NSString*) backupFieldworkFilename;

@end
