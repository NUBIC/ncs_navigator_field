//
//  DatePickerButton.h
//  NCSNavField
//
//  Created by John Dzak on 12/2/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NUPickerVC;
@class ChangeHandler;

@interface DatePicker : UIView<UIPopoverControllerDelegate> {
    NSDate* _date;
    UIButton* _button;
    NUPickerVC* _picker;
    ChangeHandler* _handler;
    UIPopoverController* _popover;
}

@property(nonatomic,strong) NSDate* date;
@property(nonatomic,strong) UIButton* button;
@property(nonatomic,strong) NUPickerVC* picker;
@property(nonatomic,strong) ChangeHandler* handler;
@property(nonatomic,strong) UIPopoverController* popover;
@property(weak, readonly,getter = getDateFormatter) NSDateFormatter* dateFormatter;

- (id)initWithFrame:(CGRect)frame value:(NSDate*)value;
- (void) addChangeHandler:(ChangeHandler*)handler;
@end
