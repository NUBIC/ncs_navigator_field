//
//  ProviderListViewController.h
//  NCSNavField
//
//  Created by John Dzak on 11/5/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProviderListViewController : UIViewController {
    NSArray* _providers;
}

@property(nonatomic,retain) NSArray* providers;

- (IBAction)cancelButtonPressed;

@end
