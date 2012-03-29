//
//  TextArea.h
//  NCSNavField
//
//  Created by John Dzak on 12/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ChangeHandler;

@interface TextArea : UIView<UITextViewDelegate> {
    ChangeHandler* _handler;
    UITextField* _textField;
    UIView* _activeField;
}

@property(nonatomic,retain) ChangeHandler* handler;

@property(nonatomic,retain) UITextView* textView;

@property(nonatomic,retain) UIView* activeField;


- (id)initWithFrame:(CGRect)frame value:(NSString*)value;


- (void) addChangeHandler:(ChangeHandler*)handler;

@end
