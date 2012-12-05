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
#import "DetailViewController.h"
#import "UIView+Additions.h"
#import "KGModal.h"

@class ContactDisplayController;
@class Instrument;
@class CasProxyTicket;
@class SyncActivityIndicator;
@class ResponseSet;
@class RKReachabilityObserver;
@class CasServiceTicket;

FOUNDATION_EXPORT NSString* const PROVIDER_SELECTED_NOTIFICATION_KEY;

@interface RootViewController : SimpleTableController<UINavigationControllerDelegate, SimpleTableRowDelegate, CasLoginDelegate, MBProgressHUDDelegate, NUSurveyTVCDelegate,UserErrorDelegate> {
    Instrument* _administeredInstrument;
    RKReachabilityObserver* _reachability;
    SyncActivityIndicator* _syncIndicator;
    CasServiceTicket* _serviceTicket;
    BlockAlertView *_alertView;
    dispatch_queue_t backgroundQueue;
    DetailViewController *_errorDetailVC; //The view that pops up when the "Details" button on the UIAlertView is pressed.
}

@property (nonatomic, strong) IBOutlet ContactDisplayController *detailViewController;
@property(nonatomic,strong) RKReachabilityObserver* reachability;
@property(nonatomic,strong) MBProgressHUD* syncIndicator;
@property(nonatomic,strong) Instrument* administeredInstrument;
@property(nonatomic,strong) CasServiceTicket* serviceTicket;
@property(nonatomic,strong) UIView *modalView;
- (void)toggleDeleteButton;
- (void)purgeDataStore;
- (void)didSelectRow:(Row*)row;
- (void)syncButtonWasPressed;
- (void)confirmSync;
- (void)startCasLogin;
- (void)deleteButtonWasPressed;
- (void)unloadSurveyor:(Instrument*)instrument;
- (void)syncContacts:(CasServiceTicket*)serviceTicket;

#pragma mark
#pragma mark - CasLoginDelegate
- (void)successfullyObtainedServiceTicket:(CasServiceTicket*)serviceTicket;
-(void)failure:(NSError *)err;

#pragma mark - TableView
- (UIView*)tableHeaderView;

@end
