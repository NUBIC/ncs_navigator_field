//
//  ProviderSynchronizeOperation.h
//  NCSNavField
//
//  Created by John Dzak on 11/7/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDate+Additions.h"
#import "UserErrorDelegate.h"

#define CONTACT_RETRIEVAL @"We were trying to retrieve your data."
#define PUTTING_DATA_ON_SERVER @"We were trying to put your data on the server."
#define STORING_CONTACTS @"We were trying to store your contacts."
#define MERGE_DATA @"We were trying to merge your data."
#define PROVIDER_RETRIEVAL @"We were trying to retrieve providers."
#define NCS_CODE_RETRIEVAL @"We were trying to get your code lists."
#define CAS_TICKET_RETRIEVAL @"We were trying to get you an authorization ticket."
#define MERGE_IS_TAKING_TIME @"It is taking longer than expected."
#define TRY_AGAIN_LATER @"Please try again later."
#define MERGE_ERROR @"There was an error preventing you from obtaining your data. Please call the help desk."
#define SYNCING_CONTACTS @"Syncing Contacts"

@interface ProviderSynchronizeOperation : NSObject<RKObjectLoaderDelegate> {
    CasServiceTicket* _ticket;
    id<UserErrorDelegate> _delegate;
}

@property(nonatomic,strong) CasServiceTicket* ticket;
@property(nonatomic,strong) id<UserErrorDelegate> delegate;
- (id) initWithServiceTicket:(CasServiceTicket*)ticket;

- (BOOL)perform;

@end
