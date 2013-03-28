//
//  ProviderListViewController.m
//  NCSNavField
//
//  Created by John Dzak on 11/5/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "ProviderListViewController.h"
#import "Provider.h"

@implementation ProviderListViewController

NSString* const PROVIDER_SELECTED_NOTIFICATION_KEY = @"ProviderSelected";

@synthesize providers = _providers;
@synthesize additionalNotificationContext = _additionalNotificationContext;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSPredicate* p = [NSPredicate predicateWithFormat:@"recruited = %d", TRUE];
        self.providers = [Provider findAllSortedBy:@"name" ascending:YES withPredicate:p];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return UIInterfaceOrientationLandscapeLeft | UIInterfaceOrientationLandscapeRight;
}

-(void)cancelButtonPressed {
    [self dismissModalViewControllerAnimated:NO];
}

#pragma mark - UITableViewDataSource Methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    Provider* provider = [self.providers objectAtIndex:indexPath.row];
    cell.textLabel.text = provider.name;
    if (provider.addressOne && provider.unit) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ (%@)", provider.addressOne, provider.unit];
    }
    else if (provider.addressOne) {
        cell.detailTextLabel.text = provider.addressOne;
    }
    else {
        cell.detailTextLabel.text = @"No address provided.";
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.providers count];
}

#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Provider* p = self.providers[indexPath.row];
    if (p) {
        NSMutableDictionary* ctx = [NSMutableDictionary dictionaryWithDictionary:self.additionalNotificationContext];
        [ctx setValue:p forKey:@"provider"];
        [[NSNotificationCenter defaultCenter] postNotificationName:PROVIDER_SELECTED_NOTIFICATION_KEY object:self userInfo:ctx];
        [self dismissModalViewControllerAnimated:NO];
    }
}

@end
