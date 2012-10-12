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

@property(nonatomic,strong) Contact* contact;
@property(nonatomic,strong) UIScrollView* scrollView;
@property(nonatomic,strong) SingleOptionPicker* dispositionPicker;

- (id)initWithContact:(Contact*)contact;
- (UIView*) toolbarWithFrame:(CGRect)frame;
- (UIView*) leftContactContentWithFrame:(CGRect)frame contact:(Contact*)contact;
- (UIView*) rightContactContentWithFrame:(CGRect)frame contact:(Contact*)contact;

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
