//
//  ContactUpdateVC.h
//  NCSMobile
//
//  Created by John Dzak on 12/4/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FormBuilder;
@class Contact;

@interface ContactUpdateVC : UIViewController {
    Contact* _contact;
}

@property(nonatomic,retain) Contact* contact;

- (id)initWithContact:(Contact*)contact;
- (UIView*) toolbarWithFrame:(CGRect)frame;
- (UIView*) leftContentWithFrame:(CGRect)frame;
- (UIView*) rightContentWithFrame:(CGRect)frame;

- (void) cancel;
- (void) done;

- (void) startTransaction;
- (void) endTransction;
- (void) commitTransaction;
- (void) rollbackTransaction;

@end
