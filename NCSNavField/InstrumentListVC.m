//
//  ContinueContact.m
//  NCSNavField
//
//  Created by John Dzak on 12/14/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "InstrumentListVC.h"
#import "Contact.h"
#import "Event.h"
#import "Instrument.h"

@implementation InstrumentListVC

@synthesize contact = _contact;
@synthesize sections = _sections;
@synthesize instruments = _instruments;
@synthesize headerLabel = _headerLabel;
@synthesize tableView = _tableView;

- (void)setContact:(Contact *)contact {
    [_contact release];
    _contact = [contact retain];
    [self configureView];
}

- (void) configureView {
    self.instruments = [self instrumentsForContact:self.contact];
}

- instrumentsForContact:(Contact*)contact {
    NSMutableArray* instruments = [[NSMutableArray alloc] init];
    for (Event* e in contact.events) {
        for (Instrument* i in e.instruments) {
            [instruments addObject:i];
        }
    }
    return instruments;
}

- (IBAction)cancel {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)closeContact {
    [self dismissViewControllerAnimated:NO completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CloseContactSelected" object:self];
    }];
}

#pragma mark - Table datasource and delegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.instruments count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"Instrument";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier] autorelease];
        cell.backgroundColor = [UIColor redColor];
    }
    
    // Configure the cell
    Instrument *instrument = [self.instruments objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ - %@", instrument.event.name, instrument.name, nil];
    cell.textLabel.font = [UIFont systemFontOfSize:16];
//    cell.layer.borderColor = [[UIColor grayColor] CGColor];
//    cell.layer.borderWidth = 1;

// TODO: mark as checked if completed
//    if (recipeType == recipe.type) {
//        cell.accessoryType = UITableViewCellAccessoryCheckmark;
//    }
    
    return cell;}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self dismissViewControllerAnimated:NO completion:^{
        Instrument* selected = [self.instruments objectAtIndex:indexPath.row];
        NSDictionary* dict = [[[NSDictionary alloc] initWithObjectsAndKeys:selected, @"instrument", nil] autorelease];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"InstrumentSelected" object:self userInfo:dict];        
    }];
}

#pragma mark - lifecycle methods

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

@end
