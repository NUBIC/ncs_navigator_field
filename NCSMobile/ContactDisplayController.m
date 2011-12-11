
//  DetailViewController.m
//  NCSMobile
//
//  Created by John Dzak on 8/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ContactDisplayController.h"

#import "RootViewController.h"
#import "ContactTable.h"
#import "ContactUpdateVC.h"
#import "TempTooController.h"

#import "Event.h"
#import "Section.h"
#import "Row.h"
#import "Contact.h"
#import "Person.h"

@interface ContactDisplayController ()
@property (nonatomic, retain) UIPopoverController *popoverController;
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

#pragma mark - Managing the detail item

/*
 When setting the detail item, update the view and dismiss the popover controller if it's showing.
 */
- (void)setDetailItem:(Contact*)newDetailItem
{
    if (_detailItem != newDetailItem) {
        [_detailItem release];
        _detailItem = [newDetailItem retain];
        
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
    // Update the user interface for the detail item.
    Contact *c = self.detailItem;
    self.simpleTable = [[ContactTable alloc]initUsingContact:c];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM dd 'at' HH:mm"];
    self.eventDateLabel.text = [dateFormatter stringFromDate:c.startDate];
//    self.dwellingIdLabel.text = [self.detailItem dwelling].id;
    UILabel *header = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 44)];
    header.backgroundColor = [UIColor groupTableViewBackgroundColor];
    header.textAlignment = UITextAlignmentCenter;
    header.text = c.person.name;
    header.font = [UIFont fontWithName:@"Arial" size:26]; 
    self.tableView.tableHeaderView = header;
    [self.tableView reloadData];
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
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
    if ([rowClass isEqualToString:@"instrument"]) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1  reuseIdentifier:rowClass] autorelease];
        cell.textLabel.font =[[UIFont fontWithName:@"Arial" size:16] autorelease];
    } else {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2  reuseIdentifier:rowClass] autorelease];
        cell.textLabel.numberOfLines = 0;
        cell.detailTextLabel.numberOfLines = 0;
    }
    return cell;
}

- (void) didSelectRow:(Row*)row {
    NSString* rc = row.rowClass;
    if ([rc isEqualToString:@"instrument"]) {
        [UIAppDelegate.rootViewController loadSurveyor:row.entity];

        //    [self.view deselectRowAtIndexPath:indexPath animated:YES]; 
        //    UITableViewCell *oldCell = [self.view cellForRowAtIndexPath:indexPath];
        
        NSDateFormatter *f = [NSDateFormatter new];
        [f setDateStyle:NSDateFormatterShortStyle];
        [f setTimeStyle:NSDateFormatterShortStyle];
//        NSDate *d = [NSDate new];
        
        //    oldCell.detailTextLabel.text = [NSString stringWithFormat:@"Completed %@", [f stringFromDate:d]];
        
    } else if ([rc isEqualToString:@"contact"]) {
        ContactUpdateVC* cc = [[ContactUpdateVC alloc] initWithContact:self.detailItem];
        cc.modalPresentationStyle = UIModalPresentationFormSheet;
        
//        ContactUpdateController* cc = [[ContactUpdateController alloc] initWithNibName:@"ContactUpdateController" bundle:nil];
//        ContactDetailController* cc = [[ContactDetailController alloc] initWithStyle:UITableViewStyleGrouped];
//        cc.ta
        NSLog(@"Row.entity: %@", row.entity);
//        [UIAppDelegate.rootViewController.navigationController presentModalViewController:self.contactDetailController animated:YES];
        [self presentModalViewController:cc animated:YES];
//        cc.view.superview.frame = CGRectMake(10, 20, 600, self.view.frame.size.height);
//        cc.view.superview.center = self.view.center;

    }
}

#pragma mark - Split view support

- (void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController: (UIPopoverController *)pc
{
    barButtonItem.title = @"Events";
    NSMutableArray *items = [[self.toolbar items] mutableCopy];
    [items insertObject:barButtonItem atIndex:0];
    [self.toolbar setItems:items animated:YES];
    [items release];
    self.popoverController = pc;
}

// Called when the view is shown again in the split view, invalidating the button and popover controller.
- (void)splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    NSMutableArray *items = [[self.toolbar items] mutableCopy];
    [items removeObjectAtIndex:0];
    [self.toolbar setItems:items animated:YES];
    [items release];
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

- (void)dealloc
{
    [_myPopoverController release];
    [_toolbar release];
    [_detailItem release];
    [_detailDescriptionLabel release];
    [super dealloc];
}

@end
