//
//  ContactUpdateVC.h
//  NCSNavField
//
//  Created by John Dzak on 12/4/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Additions.h"

@class FormBuilder;
@class Contact;

@protocol ContactInitiateDelegate;

@interface ContactInitiateVC : UIViewController {
    Contact* _contact;
}

@property (nonatomic, weak) id<ContactInitiateDelegate>delegate;

@property(nonatomic,strong) Contact* contact;
@property(nonatomic,strong) UIView *left,*right;
@property (nonatomic, assign) BOOL shouldDeleteContactOnCancel;
@property (nonatomic, copy) void (^optionalCancelBlock)(Contact* c);

- (id)initWithContact:(Contact *)contact;
- (void) setDefaults:(Contact*) contact;
- (UIView*) leftContentWithFrame:(CGRect)frame;
- (UIView*) rightContentWithFrame:(CGRect)frame;

- (void) cancel;
- (void) done;

@end

@protocol ContactInitiateDelegate <NSObject>

-(void)contactInitiateVCDidCancel:(ContactInitiateVC *)contactInitiateVC;
-(void)contactInitiateVC:(ContactInitiateVC *)contactInitiateVC didContinueWithContact:(Contact *)chosenContact;

@end
