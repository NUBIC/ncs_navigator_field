//
//  NUEndpointCollectionViewController.m
//  NCSNavField
//
//  Created by Jacob Van Order on 2/14/13.
//  Copyright (c) 2013 Northwestern University. All rights reserved.
//

#import "NUEndpointCollectionViewController.h"

#import "MBProgressHUD.h"

#import "ApplicationInformation.h"

#import "NUEndpoint.h"
#import "NUEndpointCollectionViewCell.h"

@interface NUEndpointCollectionViewController () <UIAlertViewDelegate>

@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *mainEndpointArray;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *reloadButton;

@property (nonatomic, strong) UIAlertView *environmentAlert;
@property (nonatomic, strong) NUEndpoint *chosenEndpoint;

-(void)loadEndpointArray:(NSArray *)endpointArray;
- (IBAction)cancelButtonTapped:(id)sender;
-(void)enableRefresh;

@end

@implementation NUEndpointCollectionViewController

#pragma mark delegate methods

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != 0) {
        self.chosenEndpoint.enviroment = self.chosenEndpoint[[alertView buttonTitleAtIndex:buttonIndex]];
        [self.delegate endpointCollectionViewController:self didChooseEndpoint:self.chosenEndpoint];
    }
    self.environmentAlert = nil;
}

#pragma mark customization

-(void)setIsLoading:(NSNumber *)isLoading {
    if ([isLoading isEqualToNumber:@(YES)]) {
        MBProgressHUD *progressView = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        progressView.labelText = @"Loading";
        self.reloadButton.enabled = NO;
    }
    else {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
    _isLoading = isLoading;
}

-(void)loadEndpointArray:(NSArray *)endpointArray {
    self.mainEndpointArray = endpointArray;
    [self.collectionView reloadData];
}

-(void)enableRefresh {
    self.reloadButton.enabled = YES;
}

- (IBAction)cancelButtonTapped:(id)sender {
    [self.delegate endpointCollectionViewControllerDidPressCancel:self];
}

- (IBAction)getEndpointsFromService:(id)sender {
    self.isLoading = @(YES);
    NUEndpointCollectionViewController __weak *weakSelf = self;
    [[NUEndpointService service] getEndpointArrayWithCallback:^(NSArray *endpointArray, NSError *error) {
        if (endpointArray.count > 0) {
            weakSelf.isLoading = @(NO);
            [weakSelf loadEndpointArray:endpointArray];
        }
        else {
            weakSelf.isLoading = @(NO);
            UIAlertView *issueAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                     message:[NSString stringWithFormat:@"There was an network error: %i", error.code]
                                                                    delegate:nil
                                                           cancelButtonTitle:@"Okay"
                                                           otherButtonTitles: nil];
            [issueAlertView show];
            [weakSelf enableRefresh];
        }
    }];
}

#pragma mark prototyping

#pragma mark stock code



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([NUEndpointCollectionViewCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"NUEndpointCell"];
    [self.collectionView registerClass:[NUEndpointCollectionViewCell class] forCellWithReuseIdentifier:@"NUEndpointCell"];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark collectionView data source

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ReuseIdentifier = @"NUEndpointCell";
    NUEndpointCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ReuseIdentifier forIndexPath:indexPath];
    [cell loadCellDataFromEndpoint:self.mainEndpointArray[indexPath.row]];
    return cell;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.mainEndpointArray count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

#pragma mark collectionView delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NUEndpoint *endpoint = self.mainEndpointArray[indexPath.row];
    if ([endpoint.isManualEndpoint isEqualToNumber:@YES]) {
        [self.delegate endpointCollectionViewController:self didChooseEndpoint:endpoint];
    }
    else {
        if ([ApplicationInformation isTestEnvironment]) {
            self.chosenEndpoint = endpoint;
            self.environmentAlert = [[UIAlertView alloc] initWithTitle:@"Which environment?" message:@"Please choose which endpoint environment you'd like to connect to." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: nil];
            for (NSString *environmentTitle in [self.chosenEndpoint.environmentArray valueForKeyPath:@"name"]) {
                if (![environmentTitle isEqualToString:PRODUCTION_ENVIRONMENT]) {
                    [self.environmentAlert addButtonWithTitle:environmentTitle];
                }
            }
            [self.environmentAlert show];
        }
        else {
            endpoint.enviroment = endpoint[PRODUCTION_ENVIRONMENT];
            [self.delegate endpointCollectionViewController:self didChooseEndpoint:endpoint];
        }
    }
}

- (void)viewDidUnload {
    [self setCancelButton:nil];
    [self setReloadButton:nil];
    [super viewDidUnload];
}

@end
