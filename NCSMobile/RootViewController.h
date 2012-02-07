//
//  RootViewController.h
//  NCSMobile
//
//  Created by John Dzak on 8/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>
#import "SimpleTableController.h"
#import "SimpleTableRowDelegate.h"
#import "MBProgressHUD.h"

@class ContactDisplayController;
@class Instrument;
@class CasProxyTicket;
@class SyncActivityIndicator;

@interface RootViewController : SimpleTableController<RKObjectLoaderDelegate,UINavigationControllerDelegate, SimpleTableRowDelegate, CasLoginDelegate, MBProgressHUDDelegate> {
    Instrument* _administeredInstrument;
    RKReachabilityObserver* _reachability;
    SyncActivityIndicator* _syncIndicator;
}

		
@property (nonatomic, retain) IBOutlet ContactDisplayController *detailViewController;
@property(nonatomic,retain) RKReachabilityObserver* reachability;
@property(nonatomic,retain) MBProgressHUD* syncIndicator;
@property(nonatomic,retain) Instrument* administeredInstrument;

- (void)purgeContacts;
- (void)purgeSurveyor;
- (void) loadSurveyor:(Instrument*)instrument;
- (void) didSelectRow:(Row*)row;
- (void)loadDataWithProxyTicket:(CasProxyTicket*)ticket;
- (void)loadObjectsFromDataStore;
- (void)syncButtonWasPressed;
- (void) confirmSync;
- (void) startCasLogin;
- (void) deleteButtonWasPressed;
- (void) unloadSurveyor:(Instrument*)instrument responseSet:(NUResponseSet*)rs;

- (void)successfullyObtainedServiceTicket:(CasServiceTicket*)serviceTicket;
- (void)retrieveContacts:(CasServiceTicket*)serviceTicket;

@end
