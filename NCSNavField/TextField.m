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

- (UITextField*)buildTextFieldWithValue:(NSString*)value {
    UITextField* t = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
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
/*
 Use this if you need to make the textfield accept numbers only.
 */
- (id)initWithFrame:(CGRect)frame value:(NSString*)value numbersOnly:(BOOL)bNumsOnly
{
    self = [super initWithFrame:frame];
    if (self) {
        self.bNumbersOnly=bNumsOnly;
        self.textField = [self buildTextFieldWithValue:value];
        [self.textField setKeyboardType:UIKeyboardTypeNumberPad];
        [self addSubview:self.textField];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame value:(NSString*)value {
    self = [super initWithFrame:frame];
    if (self) {
        self.textField = [self buildTextFieldWithValue:value];        
        [self addSubview:self.textField];
    }
    return self;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(self.bNumbersOnly) {
        NSCharacterSet *myCharSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789\n"];
        for (int i = 0; i < [string length]; i++) {
            unichar c = [string characterAtIndex:i];
            if (![myCharSet characterIsMember:c]) {
                return NO;
            }
        }
        return YES;
    }
    else
        return YES;

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
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


@end
