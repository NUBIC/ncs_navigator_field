//
//  RootViewController.h
//  NCSNavField
//
//  Created by John Dzak on 8/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SimpleTableController.h"
#import "SimpleTableRowDelegate.h"
#import "MBProgressHUD.h"
#import "CasLoginDelegate.h"
#import "NcsCodeSynchronizeOperation.h"
#import "BlockUI.h"
#import "BlockAlertView.h"
#import "BlockBackground.h"
#import "FieldworkSynchronizationException.h"
#import "UserErrorDelegate.h"

#import "SendOnlyDelegateObject.h"

@class ContactDisplayController;
@class Instrument;
@class CasProxyTicket;
@class SyncActivityIndicator;
@class ResponseSet;
@class RKReachabilityObserver;
@class CasServiceTicket;

FOUNDATION_EXPORT NSString* const PROVIDER_SELECTED_NOTIFICATION_KEY;

@interface RootViewController : SimpleTableController<UINavigationControllerDelegate, SimpleTableRowDelegate, MBProgressHUDDelegate, NUSurveyTVCDelegate,UserErrorDelegate, SendOnlyDelegate> {
    Instrument* _administeredInstrument;
    RKReachabilityObserver* _reachability;
    SyncActivityIndicator* _syncIndicator;
    CasServiceTicket* _serviceTicket;
    BlockAlertView *_alertView;
    dispatch_queue_t backgroundQueue;
}

@property (nonatomic, strong) IBOutlet ContactDisplayController *detailViewController;
@property (nonatomic,strong) RKReachabilityObserver* reachability;
@property (nonatomic,strong) MBProgressHUD* syncIndicator;
@property (nonatomic,strong) Instrument* administeredInstrument;
@property (nonatomic,strong) CasServiceTicket* serviceTicket;
 
- (void)toggleDeleteButton;
- (void)purgeDataStore;
- (void)didSelectRow:(Row*)row;
- (void)syncButtonWasPressed;
-(void)setUpEndpointBar;
- (void)confirmSync;
- (void)startCasLoginWithRetrieval:(BOOL)shouldRetrieve;
- (void)deleteButtonWasPressed;
- (void)unloadSurveyor:(Instrument*)instrument;
- (void)syncContacts:(CasServiceTicket*)serviceTicket withRetrieval:(BOOL)shouldRetrieve;

#pragma mark
#pragma mark - CasLoginDelegate
- (void)casLoginVC:(id)casLoginVC didSuccessfullyObtainedServiceTicket:(CasServiceTicket *)serviceTicket;
- (void)failure:(NSError *)err;

#pragma mark - TableView
- (UIView*)tableHeaderView;

@end
