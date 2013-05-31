//
//  SingleOptionPickerButton.h
//  NCSNavField
//
//  Created by John Dzak on 12/6/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIView+Additions.h"
#import "MdesCode.h"
#import "SingleOptionPickerDelegate.h"

#import "FormElementProtocol.h"

@class NUPickerVC;
@class ChangeHandler;

typedef NSUInteger NUPickerVCPopoverSize;
enum {
    NUPickerVCPopoverSizeRegular,
    NUPickerVCPopoverSizeLarge
};

@interface SingleOptionPicker : UIView <UIPopoverControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, FormElementProtocol> {
    NSObject* _value;
    UIButton* _button;
    NUPickerVC* _picker;
    ChangeHandler* _handler;
    NSArray* _pickerOptions;
    UIPopoverController* _popover;
    NUPickerVCPopoverSize _popoverSize;
    CGFloat _widthOfNUPicker; //This is set by looking at the length of the strings that represent the options.
    UITapGestureRecognizer *_doubleTapRecognizer;
    UILabel *_lblPopover;
    id<SingleOptionPickerDelegate> _singleOptionPickerDelegate;
}

@property(nonatomic,strong) NSObject* value;

@property(nonatomic,strong) UIButton* button;

@property(nonatomic,strong) NUPickerVC* picker;

@property(nonatomic,strong) ChangeHandler* handler;

@property(nonatomic,strong) NSArray* pickerOptions;

@property(nonatomic,strong) UIPopoverController* popover;

@property(nonatomic) NUPickerVCPopoverSize popoverSize;

@property(nonatomic,readonly) CGFloat widthOfNUPicker;

@property(nonatomic,strong) id<SingleOptionPickerDelegate> singleOptionPickerDelegate;

- (id)initWithFrame:(CGRect)frame value:(NSNumber*)value pickerOptions:(NSArray*)options;

- (id)initWithFrame:(CGRect)frame value:(NSNumber*)value pickerOptions:(NSArray*)options popoverSize:(NUPickerVCPopoverSize)popoverSize;

- (void) addChangeHandler:(ChangeHandler*)handler;

- (CGSize) CGSizeFromPopoverSize:(NUPickerVCPopoverSize)size;

- (void) updatePickerOptions:(NSArray*)newOptions;

- (void) clearResponse;

-(NSArray*)textSelections;

-(BOOL)hasValue;

-(BOOL)isVisible;

- (void)setHidden:(BOOL)hidden;

-(void)setAlpha:(CGFloat)alpha;

-(NSString*)text;

-(void)updatePicker;

@end
