//
//  NUManualEndpointEditViewController.h
//  NCSNavField
//
//  Created by Jacob Van Order on 4/4/13.
//  Copyright (c) 2013 Northwestern University. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NUEndpoint;

@protocol NUManualEndpointDelegate;

@interface NUManualEndpointEditViewController : UIViewController

@property (nonatomic, weak) id <NUManualEndpointDelegate> delegate;
@property (nonatomic, strong) NUEndpoint *alteredEndpoint;

@end

@protocol NUManualEndpointDelegate <NSObject>

-(void) manualEndpointViewController:(NUManualEndpointEditViewController *)manualEditVC didFinishWithEndpoint:(NUEndpoint *)alteredEndpoint;
-(void) manualEndpointViewControllerDidCancel:(NUManualEndpointEditViewController *)manualEditVC;

@end
