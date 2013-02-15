//
//  NUEndpointCollectionViewController.h
//  NCSNavField
//
//  Created by Jacob Van Order on 2/14/13.
//  Copyright (c) 2013 Northwestern University. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NUEndpointCollectionViewDelegate;

@interface NUEndpointCollectionViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) id <NUEndpointCollectionViewDelegate> delegate;

@property (nonatomic, strong) NSNumber *isLoading;

- (IBAction)getEndpointsFromService:(id)sender;

@end

@protocol NUEndpointCollectionViewDelegate <NSObject>

-(void)endpointCollectionViewControllerDidPressCancel:(NUEndpointCollectionViewController *)collectionView;
-(void)endpointCollectionViewController:(NUEndpointCollectionViewController *)collectionView didChooseEndpoint:(NUEndpoint *)chosenEndpoint;

@end
