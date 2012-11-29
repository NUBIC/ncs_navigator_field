//
//  MergeStatus.m
//  NCSNavField
//
//  Created by John Dzak on 5/29/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "MergeStatus.h"
#import <SBJson/SBJSON.h>

@implementation MergeStatus

@dynamic status, mergeStatusId, createdAt;

+ (id) parseFromJson:(NSString*)json {
    SBJSON* sb = [[SBJSON alloc] init];
    NSDictionary* dict = [sb objectWithString:json];
    MergeStatus* ms = [MergeStatus object];
    id s = [dict objectForKey:@"status"];
    ms.status = (s == [NSNull null]) ? nil : s ;
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

- (BOOL) isConflict {
    return [self isStatus:@"conflict"];
}

- (BOOL) isError {
    return [self isStatus:@"error"];
}

- (BOOL) isStatus:(NSString*)status {
    return self.status && [self.status rangeOfString:status options:NSCaseInsensitiveSearch].location != NSNotFound;
}

+ (MergeStatus*) latest {
    return [[MergeStatus findAllSortedBy:@"createdAt" ascending:YES] lastObject];
}

+ (NSString*)mergeStatusIdFromUri:(NSString*)uri {
    NSString* ident = NULL;
    if (uri) {
        NSString* rel = [[[NSURL alloc] initWithString:uri] relativePath];
        ident = [[rel componentsSeparatedByString:@"/"] lastObject];
    }
    return ident;
}

@end
