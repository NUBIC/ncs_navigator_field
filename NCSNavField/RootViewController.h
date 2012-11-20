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

@class ContactDisplayController;
@class Instrument;
@class CasProxyTicket;
@class SyncActivityIndicator;
@class ResponseSet;
@class RKReachabilityObserver;
@class CasServiceTicket;

FOUNDATION_EXPORT NSString* const PROVIDER_SELECTED_NOTIFICATION_KEY;

@interface RootViewController : SimpleTableController<UINavigationControllerDelegate, SimpleTableRowDelegate, CasLoginDelegate, MBProgressHUDDelegate, NUSurveyTVCDelegate> {
    Instrument* _administeredInstrument;
    RKReachabilityObserver* _reachability;
    SyncActivityIndicator* _syncIndicator;
    CasServiceTicket* _serviceTicket;
}

@property (nonatomic, strong) IBOutlet ContactDisplayController *detailViewController;
@property(nonatomic,strong) RKReachabilityObserver* reachability;
@property(nonatomic,strong) MBProgressHUD* syncIndicator;
@property(nonatomic,strong) Instrument* administeredInstrument;
@property(nonatomic,strong) CasServiceTicket* serviceTicket;
- (void)toggleDeleteButton;
- (void)purgeDataStore;
- (void)loadSurveyor:(Instrument*)instrument;
- (void)didSelectRow:(Row*)row;
- (void)syncButtonWasPressed;
- (void)confirmSync;
- (void)startCasLogin;
- (void)deleteButtonWasPressed;
- (void)unloadSurveyor:(Instrument*)instrument;
- (void)syncContacts:(CasServiceTicket*)serviceTicket;
- (void)successfullyObtainedServiceTicket:(CasServiceTicket*)serviceTicket;

#pragma mark - TableView
- (UIView*)tableHeaderView;

@end
