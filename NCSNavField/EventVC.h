//
//  EventVC.h
//  NCSNavField
//
//  Created by John Dzak on 6/29/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Additions.h"
#import "SingleOptionPickerDelegate.h"
#import "FormBuilder.h"

@class Event;
@class NUScrollView;

@interface EventVC : UIViewController<SingleOptionPickerDelegate> {
    Event* _event;
    UIScrollView* _scrollView;
    FormBuilder* _leftFormBuilder,*_rightFormBuilder;
}

@property(nonatomic,strong) Event* event;
@property(nonatomic,strong) UIScrollView* scrollView;
@property(nonatomic,strong) UIView *left,*right;
@property(nonatomic,strong) FormBuilder *leftFormBuilder,*rightFormBuilder;

- (id)initWithEvent:event;

- (UIView*) toolbarWithFrame:(CGRect)frame;

- (void) setDefaults:(Event*)event;

- (UIView*) leftEventContentWithFrame:(CGRect)frame event:(Event*)e;
- (UIView*) rightEventContentWithFrame:(CGRect)frame event:(Event*)e;

- (void) cancel;
- (void) done;

- (void) startTransaction;
- (void) endTransction;
- (void) commitTransaction;
- (void) rollbackTransaction;

- (void)registerForKeyboardNotifications;

#pragma mark - SingleOptionPickerDelegate

-(void)selectionWasMade:(NSString*)str;

@end
