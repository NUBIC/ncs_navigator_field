//
//  NCSMobileAppDelegate.h
//  NCSMobile
//
//  Created by John Dzak on 8/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NUCas.h"
#import "NUSurveyTVC.h"

@class RootViewController;


@class ContactDisplayController;

@interface NCSMobileAppDelegate : NSObject <UIApplicationDelegate> {
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet UISplitViewController *splitViewController;

@property (nonatomic, retain) IBOutlet RootViewController *rootViewController;

@property (nonatomic, retain) IBOutlet ContactDisplayController *detailViewController;




/* imported for surveyor_ios */
@property (nonatomic, retain) IBOutlet NUSurveyTVC *surveyController;
@property (nonatomic, retain) NUSectionTVC *sectionController;
/* */

@end
