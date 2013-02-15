//
//  NUEndpointCollectionViewController.m
//  NCSNavField
//
//  Created by Jacob Van Order on 2/14/13.
//  Copyright (c) 2013 Northwestern University. All rights reserved.
//

#import "NUEndpointCollectionViewController.h"

#import "MBProgressHUD.h"

#import "NUEndpoint.h"
#import "NUEndpointCollectionViewCell.h"

@interface NUEndpointCollectionViewController ()

@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *mainEndpointArray;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *reloadButton;

-(void)loadEndpointArray:(NSArray *)endpointArray;
- (IBAction)cancelButtonTapped:(id)sender;
-(void)enableRefresh;

@end

@implementation NUEndpointCollectionViewController

#pragma mark delegate methods

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
    [self.delegate endpointCollectionViewController:self didChooseEndpoint:self.mainEndpointArray[indexPath.row]];
}

- (void)viewDidUnload {
    [self setCancelButton:nil];
    [self setReloadButton:nil];
    [super viewDidUnload];
}

@end
