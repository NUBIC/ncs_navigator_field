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
#import "MergeStatusRequest.h"
#import "MergeStatus.h"

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
        NSString* fieldworkId = [Fieldwork submission].fieldworkId;
        BOOL submission = [self submit];
        BOOL receive = false;
        if (submission) {
            BOOL poll = [self poll:fieldworkId];
            if (poll) {
                receive = [self receive];
            }
        }
        success = submission && receive;
    } else if ([MergeStatus latest]) {
        MergeStatus* ms = [MergeStatus latest];
        BOOL poll = [self poll:ms.fieldworkId];
        if (poll) {
            success = [self receive];
        }
    } else {
        success = [self receive];
    }
    return success;
}

- (BOOL) submit {
    BOOL success = false;
    ApplicationPersistentStore* store = [ApplicationPersistentStore instance];
    ApplicationPersistentStoreBackup* backup = [store backup];
    NCSLog(@"Backup result: ", [backup path]);
    if (backup) {
        FieldworkPutRequest* put = [[FieldworkPutRequest alloc] initWithServiceTicket:self.ticket];
        if ([put send]) {
            [store remove];
            [backup remove];
            success = true;
        }
    }
    return success;
}

- (BOOL)receive {
    FieldworkStepPostRequest* post = [[FieldworkStepPostRequest alloc] initWithServiceTicket:self.ticket];
    return [post send];
}

- (BOOL) poll:(NSString*)fieldworkId {
    MergeStatusRequest* request = [[MergeStatusRequest alloc] initWithFieldworkId:fieldworkId andServiceTicket:self.ticket];
    return [request poll];
}

@end
