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
#import "ApplicationPersistentStoreBackup.h"

@implementation FieldworkSynchronizeOperation

@synthesize ticket = _ticket;

- (id) initWithServiceTicket:(CasServiceTicket*)ticket {
    self = [super init];
    if (self) {
        _ticket = ticket;
    }
    return self;
}

- (BOOL) perform {
    BOOL success = false;
    if ([Fieldwork submission]) {
        NSString* statusId = [self submit];
        BOOL receive = false;
        if (statusId) {
            BOOL poll = [self poll:statusId];
            if (poll) {
                receive = [self receive];
            }
        }
        success = statusId && receive;
    } else if ([MergeStatus latest]) {
        MergeStatus* ms = [MergeStatus latest];
        BOOL poll = [self poll:ms.mergeStatusId];
        if (poll) {
            success = [self receive];
        }
    } else {
        success = [self receive];
    }
    return success;
}

- (NSString*) submit {
    NSString* statusId = NULL;
    ApplicationPersistentStore* store = [ApplicationPersistentStore instance];
    ApplicationPersistentStoreBackup* backup = [store backup];
    NCSLog(@"Backup path: %@", [backup path]);
    if (backup) {
        FieldworkPutRequest* put = [[FieldworkPutRequest alloc] initWithServiceTicket:self.ticket];
        if ([put send]) {
            [store remove];
            [ApplicationPersistentStoreBackup removeAll];
            statusId = [put mergeStatusId];
        }
    }

    return statusId;
}

- (BOOL)receive {
    FieldworkStepPostRequest* post = [[FieldworkStepPostRequest alloc] initWithServiceTicket:self.ticket];
    return [post send];
}

- (BOOL) poll:(NSString*)mergeStatusId {
    MergeStatusRequest* request = [[MergeStatusRequest alloc] initWithMergeStatusId:mergeStatusId andServiceTicket:self.ticket];
    return [request poll];
}


@end
