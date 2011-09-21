
//  DetailViewController.m
//  NCSMobile
//
//  Created by John Dzak on 8/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DetailViewController.h"

#import "RootViewController.h"
#import "ContactPresenter.h"

#import "Event.h"
#import "Dwelling.h"
#import "Section.h"
#import "Row.h"
#import "Contact.h"
#import "Person.h"

@interface DetailViewController ()
@property (nonatomic, retain) UIPopoverController *popoverController;
- (void)configureView;
@end

@implementation DetailViewController

@synthesize toolbar=_toolbar;

@synthesize detailItem=_detailItem;

@synthesize detailDescriptionLabel=_detailDescriptionLabel;

@synthesize eventDateLabel=_eventDateLabel;

@synthesize popoverController=_myPopoverController;

@synthesize dwellingIdLabel=_dwellingIdLabel;

@synthesize presenter=_presenter;
@synthesize tableView=_tableView;

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
    self.presenter = [[ContactPresenter alloc]initUsingContact:c];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM dd 'at' HH:mm"];
    self.eventDateLabel.text = [dateFormatter stringFromDate:c.startDate];
//    self.dwellingIdLabel.text = [self.detailItem dwelling].id;
    UILabel *header = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 44)];
    header.backgroundColor = [UIColor groupTableViewBackgroundColor];
    header.textAlignment = UITextAlignmentCenter;
    header.text = c.person.name;
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    Section *s = [self.presenter.sections objectAtIndex:section];
    return [s.rows count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        // TODO: Ugly, structure this
        if (indexPath.section == 2) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:CellIdentifier] autorelease];
                cell.textLabel.font =[UIFont fontWithName:@"Arial" size:16];
        } else {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2  reuseIdentifier:CellIdentifier] autorelease];
            cell.textLabel.numberOfLines = 0;
            cell.detailTextLabel.numberOfLines = 0;
        }
    }
    
    Section *s = [self.presenter.sections objectAtIndex:indexPath.section];
    Row *r = [s.rows objectAtIndex:indexPath.row];
    cell.textLabel.text = r.text;
    cell.detailTextLabel.text = r.detailText;
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.presenter.sections count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    Section *s = [self.presenter.sections objectAtIndex:section];
    return s.name;
}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    if (section != 0) {
//        return self.tableView.tableHeaderView;
//    }
//    // Create a header view. Wrap it in a container to allow us to position
//    // it better.
//    //
//	// create the parent view that will hold header Label
////    NSLog(self.view.frame.size.width )
////	UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(10.0, 0.0, self.view.frame.size.width - 20, 200.0)];
//	
//	// create the button object
////	UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//    UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 0.0, self.view.frame.size.width  - 20, 100.0)];
//	headerLabel.backgroundColor = [UIColor redColor];
//	headerLabel.opaque = NO;
//	headerLabel.textColor = [UIColor blackColor];
//	headerLabel.highlightedTextColor = [UIColor whiteColor];
//	headerLabel.font = [UIFont boldSystemFontOfSize:20];
//	headerLabel.frame = CGRectMake(10.0, 0.0, self.view.frame.size.width  - 20, 100.0);
//    [headerLabel sizeToFit];
//    headerLabel.textAlignment = UITextAlignmentCenter;
//    
//	// If you want to align the header text as centered
////	headerLabel.frame = CGRectMake(150.0, 0.0, 300.0, 44.0);
//    
//	headerLabel.text = @"Poop";
////    customView.center
////	[customView addSubview:headerLabel];
////    [customView setNeedsLayout];
//    
//	return headerLabel;
//}

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
