//
//  TimePicker.h
//  NCSNavField
//
//  Created by John Dzak on 4/4/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import <CoreData/CoreData.h>

@class NUPickerVC;
@class ChangeHandler;

@interface TimePicker : UIView<UIPopoverControllerDelegate> {
    NSDate* _date;
    UIButton* _button;
    NUPickerVC* _picker;
    ChangeHandler* _handler;
    UIPopoverController* _popover;
}

@property(nonatomic,retain) NSDate* date;
@property(nonatomic,retain) UIButton* button;
@property(nonatomic,retain) NUPickerVC* picker;
@property(nonatomic,retain) ChangeHandler* handler;
@property(nonatomic,retain) UIPopoverController* popover;
@property(readonly,getter = getDateFormatter) NSDateFormatter* dateFormatter;

- (id)initWithFrame:(CGRect)frame value:(NSDate*)value;
- (void) addChangeHandler:(ChangeHandler*)handler;

@end
