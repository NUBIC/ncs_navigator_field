//
//  FieldworkSynchronizer.m
//  NCSNavField
//
//  Created by John Dzak on 4/27/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "FieldworkSynchronizeOperation.h"
#import "ApplicationPersistentStore.h"
#import "FieldworkPutRequest.h"
#import "FieldworkStepPostRequest.h"
#import "Fieldwork.h"

@implementation FieldworkSynchronizeOperation

@synthesize ticket = _ticket;

- (id) initWithServiceTicket:(CasServiceTicket*)ticket {
    self = [super init];
    if (self) {
        _ticket = [ticket retain];
    }
    return self;
}

- (BOOL) perform {
    BOOL success = false;
    if ([Fieldwork submission]) {
        BOOL submission = [self submit];
        BOOL receive = false;
        if (submission) {
            receive = [self recieve];
        }
        success = submission && receive;
    } else {
        success = [self recieve];
    }
    return success;
}

- (BOOL) submit {
    BOOL success = false;
    ApplicationPersistentStore* store = [ApplicationPersistentStore instance];
    ApplicationPersistentStoreBackup* backup = [store backup];
    if (backup) {
        FieldworkPutRequest* put = [[FieldworkPutRequest alloc] initWithServiceTicket:self.ticket];
        if ([put put]) {
            [store remove];
            success = true;
        }
    }
    return success;
}

- (BOOL)recieve {
    FieldworkStepPostRequest* post = [[FieldworkStepPostRequest alloc] initWithServiceTicket:self.ticket];
    return [post send];
}

@end
