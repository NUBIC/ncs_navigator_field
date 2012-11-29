//
//  ProviderSynchronizeOperation.h
//  NCSNavField
//
//  Created by John Dzak on 11/7/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import <Foundation/Foundation.h>


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
