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

@class NUPickerVC;
@class ChangeHandler;

typedef NSUInteger NUPickerVCPopoverSize;
enum {
    NUPickerVCPopoverSizeRegular,
    NUPickerVCPopoverSizeLarge
};

@interface SingleOptionPicker : UIView<UIPopoverControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource> {
    NSNumber* _value;
    UIButton* _button;
    NUPickerVC* _picker;
    ChangeHandler* _handler;
    NSArray* _pickerOptions;
    UIPopoverController* _popover;
    NUPickerVCPopoverSize _popoverSize;
}

@property(nonatomic,strong) NSNumber* value;

@property(nonatomic,strong) UIButton* button;

@property(nonatomic,strong) NUPickerVC* picker;

@property(nonatomic,strong) ChangeHandler* handler;

@property(nonatomic,strong) NSArray* pickerOptions;

@property(nonatomic,strong) UIPopoverController* popover;

@property(nonatomic) NUPickerVCPopoverSize popoverSize;

- (id)initWithFrame:(CGRect)frame value:(NSNumber*)value pickerOptions:(NSArray*)options;

- (id)initWithFrame:(CGRect)frame value:(NSNumber*)value pickerOptions:(NSArray*)options popoverSize:(NUPickerVCPopoverSize)popoverSize;

- (void) addChangeHandler:(ChangeHandler*)handler;

- (CGSize) CGSizeFromPopoverSize:(NUPickerVCPopoverSize)size;

- (void) updatePickerOptions:(NSArray*)newOptions;

- (void) clearResponse;

@end
