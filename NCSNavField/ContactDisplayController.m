
//  DetailViewController.m
//  NCSNavField
//
//  Created by John Dzak on 8/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ContactDisplayController.h"

#import "RootViewController.h"
#import "ContactTable.h"
#import "ContactInitiateVC.h"
#import "ContactCloseVC.h"
#import "InstrumentVC.h"
#import "Event.h"
#import "Section.h"
#import "Row.h"
#import "Contact.h"
#import "Person.h"
#import "ApplicationInformation.h"
#import "EventVC.h"

@interface ContactDisplayController ()
@property (nonatomic, strong) UIPopoverController *popoverController;
- (void)configureView;
@end

@implementation ContactDisplayController

@synthesize toolbar=_toolbar;

@synthesize detailItem=_detailItem;

@synthesize detailDescriptionLabel=_detailDescriptionLabel;

@synthesize eventDateLabel=_eventDateLabel;

@synthesize popoverController=_myPopoverController;

@synthesize dwellingIdLabel=_dwellingIdLabel;

@synthesize contactDetailController=_contactDetailController;

- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contactInitiated) name:@"ContactInitiated" object:NULL];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stoppedAdministeringInstrument:) name:@"StoppedAdministeringInstrument" object:NULL];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshView) name:@"ContactClosed" object:nil];
    }
    return self;
}

- (void) contactInitiated {
    [self refreshView];
}

- (void) stoppedAdministeringInstrument:(NSNotification*)notification {
    Instrument* i = [[notification userInfo] objectForKey:@"instrument"];
    
    InstrumentVC* ivc = [[InstrumentVC alloc] initWithInstrument:i];   
    ivc.modalPresentationStyle = UIModalPresentationFullScreen;  
    [self presentViewController:ivc animated:YES completion:^{
        [self refreshView];
    }];
    [self refreshView];    
}

- (void) refreshView {
    self.simpleTable = [[ContactTable alloc]initUsingContact:self.detailItem];
    [self.tableView reloadData];
}

#pragma mark - Managing the detail item

/*
 When setting the detail item, update the view and dismiss the popover controller if it's showing.
 */
- (void)setDetailItem:(Contact*)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }

    if (self.popoverController != nil) {
        [self.popoverController dismissPopoverAnimated:YES];
    }        
}

#pragma mark - UITableView


- (void)configureView
{
    if (self.detailItem) {
        // Update the user interface for the detail item.
        Contact *c = self.detailItem;
        self.simpleTable = [[ContactTable alloc]initUsingContact:c];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MMM dd 'at' HH:mm"];
        self.eventDateLabel.text = [dateFormatter stringFromDate:c.date];
        //    self.dwellingIdLabel.text = [self.detailItem dwelling].id;
        UILabel *header = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 44)];
        header.backgroundColor = [UIColor groupTableViewBackgroundColor];
        header.textAlignment = UITextAlignmentCenter;
        header.text = c.person.name;
        header.font = [UIFont fontWithName:@"Arial" size:26]; 
        self.tableView.tableHeaderView = header;
        [self.tableView reloadData];
    } else {
        self.simpleTable = NULL;
        UITableView *myTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        
        if ([ApplicationInformation isTestEnvironment]) {
            myTable.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"test-background.png"]];
        }
        self.tableView = myTable;
    }
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    CGRect r = CGRectMake(self.view.frame.size.width-155, self.view.frame.size.height-25, 150, 25);
    UILabel* l = [[UILabel alloc] initWithFrame:r];
    l.text = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    l.textAlignment = UITextAlignmentRight;
    l.backgroundColor = [UIColor clearColor];
    [self.view addSubview:l];
    
    if ([ApplicationInformation isTestEnvironment]) {
        ((UITableView*)self.view).backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"test-background.png"]];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

#pragma mark - Table view support

- (UITableViewCell*) cellForRowClass:(NSString *)rowClass {
    UITableViewCell *cell;
    if ([rowClass isEqualToString:@"contact"] || [rowClass isEqualToString:@"instrument"] || [rowClass isEqualToString:@"instrument-details"] || [rowClass isEqualToString:@"event"]) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:rowClass];
        cell.textLabel.font =[UIFont fontWithName:@"Arial" size:20];
        cell.textLabel.textAlignment = UITextAlignmentCenter;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2  reuseIdentifier:rowClass];
        cell.textLabel.numberOfLines = 0;
        cell.detailTextLabel.numberOfLines = 0;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void) didSelectRow:(Row*)row {
    NSString* rc = row.rowClass;
    if ([rc isEqualToString:@"instrument"]) {
        Instrument* selected = row.entity;
        NSDictionary* dict = [[NSDictionary alloc] initWithObjectsAndKeys:selected, @"instrument", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"InstrumentSelected" object:self userInfo:dict]; 
    } else if ([rc isEqualToString:@"instrument-details"]) {
        Instrument* selected = row.entity;
        InstrumentVC* ivc = [[InstrumentVC alloc] initWithInstrument:selected];   
        ivc.modalPresentationStyle = UIModalPresentationFullScreen;  
        [self presentViewController:ivc animated:YES completion:NULL];
    } else if ([rc isEqualToString:@"contact"]) {
        if (self.detailItem.initiated) {
            self.simpleTable = [[ContactTable alloc]initUsingContact:self.detailItem];
            [self.tableView reloadData];
            
            ContactCloseVC* cc = [[ContactCloseVC alloc] initWithContact:self.detailItem];
            cc.modalPresentationStyle = UIModalPresentationFullScreen;  
            [self presentViewController:cc animated:YES completion:NULL];
        } else {
            ContactInitiateVC* cc = [[ContactInitiateVC alloc] initWithContact:self.detailItem];
            cc.modalPresentationStyle = UIModalPresentationFormSheet;
            [self presentViewController:cc animated:YES completion:NULL];
        }
    } else if ([rc isEqualToString:@"event"]) {
        Event* selected = row.entity;
        EventVC* evc = [[EventVC alloc] initWithEvent:selected];   
        evc.modalPresentationStyle = UIModalPresentationFullScreen;  
        [self presentViewController:evc animated:YES completion:NULL];
    }
}

#pragma mark - Split view support

- (void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController: (UIPopoverController *)pc
{
    barButtonItem.title = @"Events";
    NSMutableArray *items = [[self.toolbar items] mutableCopy];
    [items insertObject:barButtonItem atIndex:0];
    [self.toolbar setItems:items animated:YES];
    self.popoverController = pc;
}

// Called when the view is shown again in the split view, invalidating the button and popover controller.
- (void)splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    NSMutableArray *items = [[self.toolbar items] mutableCopy];
    [items removeObjectAtIndex:0];
    [self.toolbar setItems:items animated:YES];
    self.popoverController = nil;
}

/*
 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
 */

- (void)viewDidUnload
{
	[super viewDidUnload];

	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	self.popoverController = nil;
}

#pragma mark - Memory management

- (void)didReceiveMemoryWarning
{
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}


@end
