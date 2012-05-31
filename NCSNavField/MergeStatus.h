//
//  MergeStatus.h
//  NCSNavField
//
//  Created by John Dzak on 5/29/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MergeStatus : NSObject {
    NSString* _status;
}

@property(nonatomic,retain) NSString* status;

+ (id) parseFromJson:(NSString*)json;

- (BOOL)isMerged;

- (BOOL)isTimeout;

- (BOOL)isWorking;

- (BOOL)isPending;

- (BOOL)isStatus:(NSString*)status;

@end
