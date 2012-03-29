//
//  TextField.h
//  NCSNavField
//
//  Created by John Dzak on 12/7/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ChangeHandler;

@interface TextField : UIView<UITextFieldDelegate> {
    ChangeHandler* _handler;
    UITextField* _textField;
}

@property(nonatomic,retain) ChangeHandler* handler;

@property(nonatomic,retain) UITextField* textField;


- (id)initWithFrame:(CGRect)frame value:(NSString*)value;

- (void) addChangeHandler:(ChangeHandler*)handler;

+ (TextField*)activeField;

//- (void)registerForKeyboardNotifications;

@end
