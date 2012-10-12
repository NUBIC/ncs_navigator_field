//
//  TextArea.m
//  NCSNavField
//
//  Created by John Dzak on 12/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "TextArea.h"
#import "ChangeHandler.h"
#import <QuartzCore/QuartzCore.h>


@interface TextArea()
    - (UITextView*)buildTextViewWithFrame:(CGRect)frame value:(NSString*)value;
@end

@implementation TextArea

@synthesize handler = _handler;
@synthesize textView = _textView;

static TextArea* _activeField = nil;

- (UITextView*)buildTextViewWithFrame:(CGRect)frame value:(NSString*)value {
    CGRect r = CGRectMake(0, 0, frame.size.width, frame.size.height);
    UITextView* t = [[UITextView alloc] initWithFrame:r];
    t.text = value;
    t.delegate = self;

    t.editable = YES;
    t.textColor = [UIColor blackColor];
    t.font = [UIFont systemFontOfSize:17.0];
    t.backgroundColor = [UIColor whiteColor];
	t.textAlignment = UITextAlignmentLeft;
	t.autocapitalizationType = UITextAutocapitalizationTypeNone;
	t.autocorrectionType = UITextAutocorrectionTypeNo;
	t.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    t.layer.cornerRadius = 5;
    t.clipsToBounds = YES;
    t.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    t.layer.borderWidth = 1;

    return t;
}

- (id)initWithFrame:(CGRect)frame value:(NSString*)value {
    self = [super initWithFrame:frame];
    if (self) {
        self.textView = [self buildTextViewWithFrame:frame value:value];
        [self addSubview:self.textView];
    }
    return self;
}

- (void) addChangeHandler:(ChangeHandler*)handler {
    self.handler = handler;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    _activeField = self;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    _activeField = nil;
    [self.handler updatedValue:self.textView.text];
}

+ (TextArea*)activeField {
    return _activeField;
}

@end
