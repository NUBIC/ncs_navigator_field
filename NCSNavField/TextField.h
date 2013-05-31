//
//  TextField.h
//  NCSNavField
//
//  Created by John Dzak on 12/7/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FormElementProtocol.h"

@class ChangeHandler;

@interface TextField : UIView<UITextFieldDelegate, FormElementProtocol> {
    ChangeHandler* _handler;
    UITextField* _textField;
}

@property(nonatomic,strong) ChangeHandler* handler;
@property(assign) BOOL bNumbersOnly;
@property(assign) BOOL bCurrencyFormat;
@property(nonatomic,strong) UITextField* textField;

- (id)initWithFrame:(CGRect)frame value:(NSString*)value currencyFormat:(BOOL)bCurrencyOnly;
- (id)initWithFrame:(CGRect)frame value:(NSString*)value numbersOnly:(BOOL)bNumsOnly;
- (id)initWithFrame:(CGRect)frame value:(NSString*)value;

- (void) addChangeHandler:(ChangeHandler*)handler;
+ (TextField*)activeField;

//- (void)registerForKeyboardNotifications;

@end
