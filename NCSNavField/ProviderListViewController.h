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
    NSDictionary* _additionalNotificationContext;
}

@property(nonatomic,retain) NSArray* providers;

@property(nonatomic,retain) NSDictionary* additionalNotificationContext;

- (IBAction)cancelButtonPressed;

@end
