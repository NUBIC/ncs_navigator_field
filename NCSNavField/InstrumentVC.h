//
//  InstrumentVC.h
//  NCSNavField
//
//  Created by John Dzak on 4/17/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Additions.h"

@class Instrument;

@interface InstrumentVC : UIViewController {
    Instrument* _instrument;
    UIScrollView* _scrollView;
}

@property(nonatomic,strong) Instrument* instrument;
@property(nonatomic,strong) UIScrollView* scrollView;
@property(nonatomic,strong) UIView *left,*right;

- (id)initWithInstrument:(Instrument*)instrument;

- (void) setDefaults:(Instrument*)instrument;

- (UIView*) toolbarWithFrame:(CGRect)frame;
- (UIView*) leftInstrumentContentWithFrame:(CGRect)frame contact:(Instrument*)contact;
- (UIView*) rightInstrumentContentWithFrame:(CGRect)frame contact:(Instrument*)contact;

- (void) cancel;
- (void) done;

- (void) startTransaction;
- (void) endTransction;
- (void) commitTransaction;
- (void) rollbackTransaction;

- (void)registerForKeyboardNotifications;

@end
