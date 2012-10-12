//
//  ContactUpdateController
//  NCSNavField
//
//  Created by John Dzak on 8/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SimpleTableController.h"
#import "SimpleTableRowDelegate.h"

@class Contact;
@class ContactTable;
@class ContactUpdateController;

@interface ContactDisplayController : SimpleTableController <UIPopoverControllerDelegate, UISplitViewControllerDelegate, SimpleTableRowDelegate> {
    ContactUpdateController* _contactDetailController;
}

@property (nonatomic, strong) IBOutlet UIToolbar *toolbar;
@property (nonatomic, strong) Contact* detailItem;
@property (nonatomic, strong) IBOutlet UILabel *detailDescriptionLabel;
@property (nonatomic, strong) IBOutlet UILabel *eventDateLabel;
@property (nonatomic, strong) IBOutlet UILabel* dwellingIdLabel;

@property(nonatomic, strong) IBOutlet ContactUpdateController* contactDetailController;

- (void) refreshView;

@end
