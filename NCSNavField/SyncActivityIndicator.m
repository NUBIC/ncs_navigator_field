//
//  SyncActivityIndicator.m
//  NCSNavField
//
//  Created by John Dzak on 2/6/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "SyncActivityIndicator.h"

@implementation SyncActivityIndicator

- (id) initWithView:(UIView *)view {
    if (self = [super initWithView:view]) {
        self.labelText = @"Syncing Contacts";
        self.labelFont = [UIFont boldSystemFontOfSize:24];
        self.minSize = CGSizeMake(200, 200);
        self.dimBackground = YES;
    }
    return self;
}

@end
