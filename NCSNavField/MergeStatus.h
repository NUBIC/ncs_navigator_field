//
//  MergeStatus.h
//  NCSNavField
//
//  Created by John Dzak on 5/29/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MergeStatus : NSManagedObject {
    NSString* _fieldworkId;
    NSString* _status;
    NSDate* _createdAt;
}

@property(nonatomic,retain) NSString* status;

@property(nonatomic,retain) NSString* fieldworkId;

@property(nonatomic,retain) NSDate* createdAt;

+ (id) parseFromJson:(NSString*)json;

- (BOOL)isMerged;

- (BOOL)isTimeout;

- (BOOL)isWorking;

- (BOOL)isPending;

- (BOOL)isStatus:(NSString*)status;

+ (MergeStatus*) latest;

@end
