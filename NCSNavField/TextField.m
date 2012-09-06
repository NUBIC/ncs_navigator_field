//
//  TextField.m
//  NCSNavField
//
//  Created by John Dzak on 12/7/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "TextField.h"
#import "ChangeHandler.h"

@implementation TextField

@synthesize handler = _handler;
@synthesize textField = _textField;

static TextField* _activeField = nil;

- (UITextField*)initTextFieldWithValue:(NSString*)value {
    UITextField* t = [[[UITextField alloc] initWithFrame:CGRectMake(0, 0, 200, 30)] autorelease];
    t.borderStyle = UITextBorderStyleRoundedRect;
    t.textColor = [UIColor blackColor]; //text color
    t.font = [UIFont systemFontOfSize:17.0];  //font size
    t.backgroundColor = [UIColor whiteColor]; //background color
    t.autocorrectionType = UITextAutocorrectionTypeNo;	// no auto correction support
    
    t.keyboardType = UIKeyboardTypeDefault;  // type of the keyboard
    t.returnKeyType = UIReturnKeyDone;  // type of the return key
    
    t.clearButtonMode = UITextFieldViewModeWhileEditing;	// has a clear 'x' button to the right
    if (value != NULL) {
        t.text = [NSString stringWithFormat:@"%@", value];
    }
    t.delegate = self;
    return t;
}

- (id)initWithFrame:(CGRect)frame value:(NSString*)value {
    self = [super initWithFrame:frame];
    if (self) {
        self.textField = [self initTextFieldWithValue:value];        
        [self addSubview:self.textField];
    }
    return self;
}

- (void) addChangeHandler:(ChangeHandler*)handler {
    self.handler = handler;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    _activeField = self;
}

+ (TextField*)activeField {
    return _activeField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField

{
    _activeField = nil;
    [self.handler updatedValue:self.textField.text];
    
}

- (void)dealloc {
    [_textField release];
    if (_handler) {
        [_handler release];
    }
    [super dealloc];
}

@end
