//
//  ContactUpdateVC.h
//  NCSNavField
//
//  Created by John Dzak on 12/4/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FormBuilder;
@class Contact;
@class Event;
@class SingleOptionPicker;

@interface ContactCloseVC : UIViewController {
    Contact* _contact;
    UIScrollView* _scrollView;
    SingleOptionPicker* _dispositionPicker;
}

@property(nonatomic,retain) Contact* contact;
@property(nonatomic,retain) UIScrollView* scrollView;
@property(nonatomic,retain) SingleOptionPicker* dispositionPicker;

- (id)initWithContact:(Contact*)contact;
- (UIView*) toolbarWithFrame:(CGRect)frame;
- (UIView*) leftContactContentWithFrame:(CGRect)frame contact:(Contact*)contact;
- (UIView*) rightContactContentWithFrame:(CGRect)frame contact:(Contact*)contact;
- (UIView*) leftEventContentWithFrame:(CGRect)frame event:(Event*)event;
- (UIView*) rightEventContentWithFrame:(CGRect)frame event:(Event*)event;

- (void) cancel;
- (void) done;

- (void) startTransaction;
- (void) endTransction;
- (void) commitTransaction;
- (void) rollbackTransaction;

- (void)registerForKeyboardNotifications;
- (void) registerContactTypeChangeNotification;

- (void) setDefaults:(Contact*)contact;

@end
