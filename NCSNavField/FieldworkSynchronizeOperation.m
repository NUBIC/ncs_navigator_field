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
#import "FieldworkStepRetrieveContacts.h"
#import "Fieldwork.h"
#import "MergeStatusRequest.h"
#import "MergeStatus.h"
#import "ApplicationPersistentStoreBackup.h"

@implementation FieldworkSynchronizeOperation

@synthesize ticket = _ticket;
@synthesize delegate = _delegate;
- (id) initWithServiceTicket:(CasServiceTicket*)ticket {
    self = [super init];
    if (self) {
        _ticket = ticket;
    }
    return self;
}

- (BOOL) perform {
    @try {
        //#1 Does Fieldwork Need to be submitted?
        if ([Fieldwork fieldworkNeededToBeSubmitted]) {
            //#2 Let's try to put that on the server.
            NSString* statusPutRequest = [self putFieldwork];
            
            if (statusPutRequest) { 
                BOOL didMergeStatusRequestSucceed = [self doMergeStatusRequest:statusPutRequest];
                if (didMergeStatusRequestSucceed) {
                    BOOL didRetrieveContacts = [self doFieldworkRetrieveContacts];
                    if(!didRetrieveContacts)
                    {
                        [_delegate showAlertView:CONTACT_RETRIEVAL];
                        return false;
                    }
                }
                else {
                    [_delegate showAlertView:MERGE_DATA];
                    return false;
                }
            }
            else {
                [_delegate showAlertView:PUTTING_DATA_ON_SERVER];
                return false;
            }
        }
        //Fieldwork does not need to be submitted, let's look at the latest merge status and see if it exists.
        else if ([MergeStatus latestMergeStatus]) {
            MergeStatus* ms = [MergeStatus latestMergeStatus];
            BOOL didMergePollingWork = [self doMergeStatusRequest:ms.mergeStatusId];
            if (didMergePollingWork) {
                BOOL bDidReceiveContacts = [self doFieldworkRetrieveContacts];
                if(!bDidReceiveContacts)
                   [_delegate showAlertView:@"merging work"];
                return bDidReceiveContacts;
            }
        }
        //There is no merge status to attempt. 
        else {
            BOOL bDidReceiveContacts = [self doFieldworkRetrieveContacts];
            if(!bDidReceiveContacts)
                [_delegate showAlertView:CONTACT_RETRIEVAL];
            return bDidReceiveContacts;
        }
    }
    @catch(NSException *ex) {
        @throw ex;
    }
}

- (NSString*) putFieldwork {
    NSString* statusId = NULL;
    ApplicationPersistentStore* store = [ApplicationPersistentStore instance];
    ApplicationPersistentStoreBackup* backup = [store backup];
    NCSLog(@"Backup path: %@", [backup path]);
    if (backup) {
        FieldworkPutRequest* put = [[FieldworkPutRequest alloc] initWithServiceTicket:self.ticket];
        put.delegate=_delegate;
        if ([put send]) {
            [store remove];
            [ApplicationPersistentStoreBackup removeAll];
            statusId = [put mergeStatusId];
        }
    }

    return statusId;
}

- (BOOL)doFieldworkRetrieveContacts {
    FieldworkStepRetrieveContacts* post = [[FieldworkStepRetrieveContacts alloc] initWithServiceTicket:self.ticket];
    post.delegate = _delegate;
    return [post send];
}

- (BOOL) doMergeStatusRequest:(NSString*)mergeStatusId {
    MergeStatusRequest* request = [[MergeStatusRequest alloc] initWithMergeStatusId:mergeStatusId andServiceTicket:self.ticket];
    return [request poll];
}


@end
