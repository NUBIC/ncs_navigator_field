//
//  MergeStatus.h
//  NCSNavField
//
//  Created by John Dzak on 5/29/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MergeStatus : NSManagedObject

@property(nonatomic,strong) NSString* status;

@property(nonatomic,strong) NSString* mergeStatusId;

@property(nonatomic,strong) NSDate* createdAt;

+ (id) parseFromJson:(NSString*)json;

- (BOOL)isMerged;

- (BOOL)isTimeout;

- (BOOL)isWorking;

- (BOOL)isPending;

- (BOOL) isConflict;

- (BOOL) isError;

- (BOOL)isStatus:(NSString*)status;

+ (MergeStatus*) latest;

+ (NSString*)mergeStatusIdFromUri:(NSString*)uri;

@end
