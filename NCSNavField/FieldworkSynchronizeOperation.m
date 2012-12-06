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
- (NSString*)putFieldwork;
- (BOOL)retrieveContacts;
- (BOOL) mergeStatusRequest:(NSString*)mergeStatusId;
@end

@implementation FieldworkSynchronizeOperation

@synthesize ticket = _ticket;
@synthesize userAlertDelegate = _userAlertDelegate;
@synthesize loggingDelegate = _loggingDelegate;

- (id) initWithServiceTicket:(CasServiceTicket*)ticket {
    self = [super init];
    if (self) {
        _ticket = ticket;
    }
    return self;
}

- (BOOL) perform {
        NSMutableString *detailedMessage = [[NSMutableString alloc] initWithString:@"Starting to synchronize the fieldwork."];
        //#1 Does Fieldwork Need to be submitted?
        if ([Fieldwork submission]) {
            [_loggingDelegate addLine:LOG_NEED_FIELDWORK_SUBMISSION_YES];
            //#2 Let's try to put that on the server.
            NSString* statusPutRequest = [self putFieldwork];
            
            if (statusPutRequest) {
                [_loggingDelegate addLine:LOG_FIELDWORK_UPLOAD_YES];
                BOOL requestSucceeded = [self mergeStatusRequest:statusPutRequest];
                if (requestSucceeded) {
                    [_loggingDelegate addLine:LOG_MERGING_YES];
                    BOOL retrievedContacts = [self retrieveContacts];
                    if(!retrievedContacts)
                    {
                        [_loggingDelegate addLine:LOG_AUTH_SUCCESSED];
                        [_loggingDelegate addLine:LOG_RETRIEVE_CONTACTS_NO];
                        [_userAlertDelegate showAlertView:CONTACT_RETRIEVAL];
                        [FieldworkSynchronizationException raise:detailedMessage format:nil];
                    }
                    else {
                        [_loggingDelegate addLine:LOG_RETRIEVE_CONTACTS_YES];
                    }
                }
                else {
                    [_loggingDelegate addLine:LOG_MERGING_NO];
                    [_userAlertDelegate showAlertView:MERGE_DATA];
                    return false;
                }
            }
            else {
                [_userAlertDelegate showAlertView:PUTTING_DATA_ON_SERVER];
                return false;
            }
        }
        //Fieldwork does not need to be submitted, let's look at the latest merge status and see if it exists.
        else if ([MergeStatus latest]) {
            [_loggingDelegate addLine:LOG_NEED_FIELDWORK_SUBMISSION_NO];
            [_loggingDelegate addLine:LOG_NEED_MERGE_ATTEMPT_YES];
            MergeStatus* ms = [MergeStatus latest];
            BOOL mergeWorked = [self mergeStatusRequest:ms.mergeStatusId];
            if (mergeWorked) {
                [_loggingDelegate addLine:LOG_MERGING_YES];
                BOOL receivedContacts = [self retrieveContacts];
                if(!receivedContacts) {
                    [_loggingDelegate addLine:LOG_RETRIEVE_CONTACTS_NO];
                    [_loggingDelegate addLine:CONTACT_RETRIEVAL];
                    return false;
                }
                else {
                    [_loggingDelegate addLine:LOG_RETRIEVE_CONTACTS_YES];
                }
                return receivedContacts;
            }
            else {
                [_loggingDelegate addLine:LOG_MERGING_NO];
            }
        }
        //There is no merge status to attempt. 
        else {
            [_loggingDelegate addLine:LOG_NEED_FIELDWORK_SUBMISSION_NO];
            [_loggingDelegate addLine:LOG_NEED_MERGE_ATTEMPT_NO];
            BOOL receivedContacts = [self retrieveContacts];
            if(!receivedContacts)
                [_userAlertDelegate showAlertView:CONTACT_RETRIEVAL];
            return receivedContacts;
        }
    return YES;
}

- (NSString*) putFieldwork {
    NSString* statusId = NULL;
    ApplicationPersistentStore* store = [ApplicationPersistentStore instance];
    ApplicationPersistentStoreBackup* backup = [store backup];
    NCSLog(@"Backup path: %@", [backup path]);
    if (backup) {
        FieldworkPutRequest* put = [[FieldworkPutRequest alloc] initWithServiceTicket:self.ticket];
        put.userAlertDelegate=_userAlertDelegate;
        put.loggingDelegate = _loggingDelegate;
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
    post.userAlertDelegate = _userAlertDelegate;
    post.loggingDelegate = _loggingDelegate;
    return [post send];
}

- (BOOL) mergeStatusRequest:(NSString*)mergeStatusId {
    MergeStatusRequest* request = [[MergeStatusRequest alloc] initWithMergeStatusId:mergeStatusId andServiceTicket:self.ticket];
    request.userAlertDelegate = _userAlertDelegate;
    request.loggingDelegate = _loggingDelegate;
    return [request poll];
}


@end
