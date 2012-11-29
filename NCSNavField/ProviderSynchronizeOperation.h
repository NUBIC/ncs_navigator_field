//
//  ProviderSynchronizeOperation.h
//  NCSNavField
//
//  Created by John Dzak on 11/7/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CONTACT_RETRIEVAL @"We were trying to retrieve your contacts."
#define PUTTING_DATA_ON_SERVER @"We were trying to put your fieldwork data on the server."
#define STORING_CONTACTS @"We were trying to store your contacts."
#define MERGE_DATA @"We were trying to merge your data."
#define PROVIDER_RETRIEVAL @"We were trying to retrieve providers."
#define NCS_CODE_RETRIEVAL @"We were trying to get your ncs codes."
#define CAS_TICKET_RETRIEVAL @"We were trying to get you an authorization ticket."

@protocol UserErrorDelegate <NSObject>
-(void)showAlertView:(NSString*)strError;
//We should include more options to show the user additional stuff. This
//will suffice for now.
@end

@interface ProviderSynchronizeOperation : NSObject<RKObjectLoaderDelegate> {
    CasServiceTicket* _ticket;
    id<UserErrorDelegate> _delegate;
}

@property(nonatomic,strong) CasServiceTicket* ticket;
@property(nonatomic,strong) id<UserErrorDelegate> delegate;
- (id) initWithServiceTicket:(CasServiceTicket*)ticket;

- (BOOL)perform;

@end
