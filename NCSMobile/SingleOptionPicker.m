//
//  SingleOptionPickerButton.m
//  NCSMobile
//
//  Created by John Dzak on 12/6/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SingleOptionPicker.h"
#import "NUPickerVC.h"
#import "ChangeHandler.h"
#import "PickerOption.h"

@implementation SingleOptionPicker

@synthesize value = _value;

@synthesize button = _button;

@synthesize picker = _picker;

@synthesize popover = _popover;

@synthesize handler = _handler;

@synthesize pickerOptions = _pickerOptions;

- (id)initWithFrame:(CGRect)frame value:(NSNumber*)value pickerOptions:(NSArray*)options {
    self = [super initWithFrame:frame];
    if (self) {
        self.value = value;
        self.pickerOptions = options;

        
        // Create button
        self.button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.button.frame = CGRectMake(0, 0, 200, 30);
        
        // Set title
        PickerOption* title = [PickerOption findWithValue:[value integerValue] fromOptions:options];
        if (title) {
            [self.button setTitle:title.text forState:UIControlStateNormal];
        } else {
            [self.button setTitle:@"Pick One" forState:UIControlStateNormal];
        }

        // Setup button target
        [self.button addTarget:self action:@selector(showPicker) forControlEvents:UIControlEventTouchUpInside];
        
        
        [self addSubview:self.button];
    }
    return self;
}

- (void) addChangeHandler:(ChangeHandler*)handler {
    self.handler = handler;
}

- (NUPickerVC*) initPickerVC {
    NUPickerVC* p= [[[NUPickerVC alloc] initWithNibName:@"NUPickerVC" bundle:nil] autorelease];
    [p loadView];
    [p setupDelegate:self withTitle:@"Pick One" date:NO];
    p.contentSizeForViewInPopover = CGSizeMake(384.0, 260.0);

    PickerOption* title = [PickerOption findWithValue:[self.value integerValue] fromOptions:self.pickerOptions];
    if (title) {
        [self.button setTitle:title.text forState:UIControlStateNormal];
    }
    NSInteger index = [self.pickerOptions indexOfObject:title];
    [p.picker selectRow:index inComponent:0 animated:NO];
    return p;
}

- (UIPopoverController*)initPopoverVCWithPicker:(NUPickerVC*)picker {
    UIPopoverController* popoverVC = [[UIPopoverController alloc] initWithContentViewController: picker];
    popoverVC.delegate = self;
    return popoverVC;
}

- (void)showPicker {
    if (!self.picker) {
        self.picker = [self initPickerVC];
    }
    if (!self.popover) {
        self.popover = [self initPopoverVCWithPicker:self.picker];
    }
    [self.popover presentPopoverFromRect:self.frame inView:self.superview permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
}

- (void) pickerDone{
    NSUInteger selected = [self.picker.picker selectedRowInComponent:0]; 
    PickerOption* o = [self.pickerOptions objectAtIndex:selected];
    NSNumber* new = [NSNumber numberWithInteger:o.value];
    self.value = new;
    [self.handler updatedValue:new];
    [self.button setTitle:o.text forState:UIControlStateNormal];
    [self.popover dismissPopoverAnimated:NO];
}
- (void) pickerCancel{
    NSInteger old = [self.value integerValue];
    PickerOption* o = [PickerOption findWithValue:old fromOptions:self.pickerOptions];
    [self.picker.picker selectRow:[self.pickerOptions indexOfObject:o] inComponent:0 animated:NO];
    [self.popover dismissPopoverAnimated:NO];
}

#pragma mark -
#pragma mark Picker view data source

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

#pragma mark -
#pragma mark Picker view delegate

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [self.pickerOptions count];
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    PickerOption* p = [self.pickerOptions objectAtIndex:row];
    return p.text;
}


@end
