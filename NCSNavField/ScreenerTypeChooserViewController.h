//
//  ScreenerChooserViewController.h
//  NCSNavField
//
//  Created by Jacob Van Order on 4/12/13.
//  Copyright (c) 2013 Northwestern University. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ScreenerTypeChooserDelegate;

@interface ScreenerTypeChooserViewController : UIViewController

@property (nonatomic, weak) id<ScreenerTypeChooserDelegate> delegate;

@end

@protocol ScreenerTypeChooserDelegate <NSObject>

-(void)screenerTypeChooserDidCancel:(ScreenerTypeChooserViewController *)screenerTypeChooserViewController;
-(void)screenerTypeChooser:(ScreenerTypeChooserViewController *)screenerTypeChooserViewController didChooseScreenerType:(NSString *)screenerType;

@end
