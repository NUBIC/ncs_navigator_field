//
//  MergeStatus.m
//  NCSNavField
//
//  Created by John Dzak on 5/29/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "MergeStatus.h"
#import "SBJSON.h"

@implementation MergeStatus

@synthesize status=_status;

+ (id) parseFromJson:(NSString*)json {
    SBJSON* sb = [[SBJSON alloc] init];
    NSDictionary* dict = [sb objectWithString:json];
    MergeStatus* ms = [[MergeStatus alloc] init];
    ms.status = [dict valueForKey:@"status"];
    return ms;
}

- (BOOL)isMerged {
    return [self isStatus:@"merged"];
}

- (BOOL)isTimeout {
    return [self isStatus:@"timeout"];
}

- (BOOL)isWorking {
    return [self isStatus:@"working"];
}

- (BOOL)isPending {
    return [self isStatus:@"pending"];
}

- (BOOL) isStatus:(NSString*)status {
    return self.status && [self.status rangeOfString:status options:NSCaseInsensitiveSearch].location != NSNotFound;
}

@end
