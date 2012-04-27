//
//  FieldworkSynchronizer.m
//  NCSNavField
//
//  Created by John Dzak on 4/27/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "FieldworkSynchronizer.h"
#import "BackupFieldworkStep.h"

@implementation FieldworkSynchronizer

@synthesize ticket = _ticket;

- (id) initWithServiceTicket:(CasServiceTicket*)ticket {
    self = [super init];
    if (self) {
        _ticket = [ticket retain];
    }
    return self;
}

- (void) perform {
    [NSArray arrayWithObject:BackupFieldworkStep];
    BackupFieldworkStep* backup = [BackupFieldworkStep new];
    [backup perform];
    if ([backup isSuccessful]) {
        
    }
}


@end
