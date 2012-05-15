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
}

@property(nonatomic,retain) ChangeHandler* handler;

@property(nonatomic,retain) UITextView* textView;


- (id)initWithFrame:(CGRect)frame value:(NSString*)value;

+ (TextArea*)activeField;

- (void) addChangeHandler:(ChangeHandler*)handler;

@end
