//
//  NCSNavFieldAppDelegate.h
//  NCSNavField
//
//  Created by John Dzak on 8/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NUCas.h"
#import "NUSurveyTVC.h"

@class RootViewController;


@class ContactDisplayController;

@interface NCSNavFieldAppDelegate : NSObject <UIApplicationDelegate> {
}

@property (nonatomic, strong) IBOutlet UIWindow *window;

@property (nonatomic, strong) IBOutlet UISplitViewController *splitViewController;

@property (nonatomic, strong) IBOutlet RootViewController *rootViewController;

@property (nonatomic, strong) IBOutlet ContactDisplayController *detailViewController;


@end
