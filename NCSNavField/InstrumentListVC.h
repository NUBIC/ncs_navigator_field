//
//  ContinueContact.h
//  NCSNavField
//
//  Created by John Dzak on 12/14/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Contact;
@class SimpleTableController;

@interface InstrumentListVC : UIViewController<UITableViewDelegate,UITableViewDataSource> {
    Contact* _contact;
    NSArray* _instruments;
    NSArray* _sections;
    IBOutlet UILabel* _headerLabel;
    IBOutlet UITableView* _tableView;
}

@property(nonatomic,retain) Contact* contact;
@property(nonatomic,retain) NSArray* instruments;
@property(nonatomic,retain) NSArray* sections;
@property(nonatomic,retain) UILabel* headerLabel;
@property(nonatomic,retain) UITableView* tableView;

- (IBAction)cancel;
- (IBAction)closeContact;
- (void) configureView;
- instrumentsForContact:(Contact*)contact;

@end
