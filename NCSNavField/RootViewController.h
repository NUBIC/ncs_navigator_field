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

@class ContactDisplayController;
@class Instrument;
@class CasProxyTicket;
@class SyncActivityIndicator;
@class ResponseSet;

@interface RootViewController : SimpleTableController<UINavigationControllerDelegate, SimpleTableRowDelegate, CasLoginDelegate, MBProgressHUDDelegate, NUSurveyTVCDelegate> {
    Instrument* _administeredInstrument;
    RKReachabilityObserver* _reachability;
    SyncActivityIndicator* _syncIndicator;
    CasServiceTicket* _serviceTicket;
}

		
@property (nonatomic, retain) IBOutlet ContactDisplayController *detailViewController;
@property(nonatomic,retain) RKReachabilityObserver* reachability;
@property(nonatomic,retain) MBProgressHUD* syncIndicator;
@property(nonatomic,retain) Instrument* administeredInstrument;
@property(nonatomic,retain) CasServiceTicket* serviceTicket;
- (void)toggleDeleteButton;
- (void)purgeDataStore;
- (void)loadSurveyor:(Instrument*)instrument;
- (void)didSelectRow:(Row*)row;
- (void)loadObjectsFromDataStore;
- (void)syncButtonWasPressed;
- (void)confirmSync;
- (void)startCasLogin;
- (void)deleteButtonWasPressed;
- (void)unloadSurveyor:(Instrument*)instrument;
- (void)syncContacts:(CasServiceTicket*)serviceTicket;
- (void)successfullyObtainedServiceTicket:(CasServiceTicket*)serviceTicket;

@end
