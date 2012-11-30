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
#import "FieldworkRetrieveStep.h"
#import "Fieldwork.h"
#import "MergeStatusRequest.h"
#import "MergeStatus.h"
#import "ApplicationPersistentStoreBackup.h"

@interface FieldworkSynchronizeOperation() 
- (NSString*) putFieldwork;
- (BOOL)retrieveContacts;
- (BOOL) mergeStatusRequest:(NSString*)mergeStatusId;
@end

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
        if ([Fieldwork submission]) {
            //#2 Let's try to put that on the server.
            NSString* statusPutRequest = [self putFieldwork];
            
            if (statusPutRequest) { 
                BOOL requestSucceeded = [self mergeStatusRequest:statusPutRequest];
                if (requestSucceeded) {
                    BOOL retrievedContacts = [self retrieveContacts];
                    if(!retrievedContacts)
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
        else if ([MergeStatus latest]) {
            MergeStatus* ms = [MergeStatus latest];
            BOOL mergeWorked = [self mergeStatusRequest:ms.mergeStatusId];
            if (mergeWorked) {
                BOOL receivedContacts = [self retrieveContacts];
                if(!receivedContacts) {
                    [_delegate showAlertView:CONTACT_RETRIEVAL];
                    return false;
                }
                   
                return receivedContacts;
            }
        }
        //There is no merge status to attempt. 
        else {
            BOOL receivedContacts = [self retrieveContacts];
            if(!receivedContacts)
                [_delegate showAlertView:CONTACT_RETRIEVAL];
            return receivedContacts;
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

- (BOOL)retrieveContacts {
    FieldworkRetrieveStep* post = [[FieldworkRetrieveStep alloc] initWithServiceTicket:self.ticket];
    post.delegate = _delegate;
    return [post send];
}

- (BOOL) mergeStatusRequest:(NSString*)mergeStatusId {
    MergeStatusRequest* request = [[MergeStatusRequest alloc] initWithMergeStatusId:mergeStatusId andServiceTicket:self.ticket];
    return [request poll];
}


@end
