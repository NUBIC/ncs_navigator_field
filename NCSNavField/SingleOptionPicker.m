//
//  SingleOptionPickerButton.m
//  NCSNavField
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

@synthesize popoverSize = _popoverSize;

- (id)initWithFrame:(CGRect)frame value:(NSNumber*)value pickerOptions:(NSArray*)options {
    self.accessibilityLabel = @"Single Option Picker";
    self.isAccessibilityElement=YES;
    return [self initWithFrame:frame value:value pickerOptions:options popoverSize:NUPickerVCPopoverSizeRegular];
}

- (id)initWithFrame:(CGRect)frame value:(NSNumber*)value pickerOptions:(NSArray*)options popoverSize:(NUPickerVCPopoverSize)popoverSize {
    self = [super initWithFrame:frame];
    if (self) {
        self.accessibilityLabel = @"Single Option Picker";
        self.isAccessibilityElement=YES;
        
        self.value = value;
        self.pickerOptions = options;
        self.popoverSize = popoverSize;
        
        
        // Create button
        self.button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.button.frame = CGRectMake(0, 0, 200, 30);
        
        // Set title
        NSString* title = @"Pick One";
        if (value) {
            PickerOption* o = [PickerOption findWithValue:value fromOptions:options];
            if (o) {
                title = o.text;
            }
        }
        [self.button setTitle:title forState:UIControlStateNormal];
        
        // Setup button target
        [self.button addTarget:self action:@selector(showPicker) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:self.button];
    }
    return self;
}

- (void) addChangeHandler:(ChangeHandler*)handler {
    self.handler = handler;
}

- (NUPickerVC*) buildPickerVC {
    NUPickerVC* p= [[NUPickerVC alloc] init];
    [p loadView];
    [p viewDidLoad];
    [p setupDelegate:self withTitle:@"Pick One" date:NO];

    p.contentSizeForViewInPopover = [self CGSizeFromPopoverSize:self.popoverSize];

    PickerOption* title = [PickerOption findWithValue:self.value fromOptions:self.pickerOptions];
    if (title) {
        [self.button setTitle:title.text forState:UIControlStateNormal];
        NSInteger index = [self.pickerOptions indexOfObject:title];
        [p.picker selectRow:index inComponent:0 animated:NO];
    }
    return p;
}

- (CGSize) CGSizeFromPopoverSize:(NUPickerVCPopoverSize)size {
    if (size == NUPickerVCPopoverSizeLarge) {
        return CGSizeMake(1000, 260);
    } else {
        return CGSizeMake(384, 260);
    }
}

- (UIPopoverController*)buildPopoverVCWithPicker:(NUPickerVC*)picker {
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:picker];
    UIPopoverController* popoverVC = [[UIPopoverController alloc] initWithContentViewController:nav];
    popoverVC.delegate = self;
    return popoverVC;
}

- (void) updatePickerOptions:(NSArray*)newOptions {
    self.pickerOptions = newOptions;
    [self.picker.picker reloadAllComponents];
}

- (void)showPicker {
    [self postPopoverNotification];
    if (!self.picker) {
        self.picker = [self buildPickerVC];
    }
    if (!self.popover) {
        self.popover = [self buildPopoverVCWithPicker:self.picker];
    }
    [self.popover presentPopoverFromRect:self.frame inView:self.superview permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
}

- (void) pickerDone{
    NSUInteger selected = [self.picker.picker selectedRowInComponent:0]; 
    PickerOption* o = [self.pickerOptions objectAtIndex:selected];
    NSObject* new = o.value;
    self.value = new;
    [self.handler updatedValue:new];
    [self.button setTitle:o.text forState:UIControlStateNormal];
    [self.popover dismissPopoverAnimated:NO];
}
- (void) pickerCancel{
    NSObject* old = self.value;
    PickerOption* o = [PickerOption findWithValue:old fromOptions:self.pickerOptions];
    if(o!=nil)
        [self.picker.picker selectRow:[self.pickerOptions indexOfObject:o] inComponent:0 animated:NO];
    [self.popover dismissPopoverAnimated:NO];
}

- (void) clearResponse {
    [self.button setTitle:@"Pick One" forState:UIControlStateNormal];

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
    if(_popoverSize == NUPickerVCPopoverSizeRegular) {
        PickerOption* p = [self.pickerOptions objectAtIndex:row];
        return p.text;
    }
    return nil; //This should never be reached.
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
        UILabel *pickerLabel = (UILabel *)view;
        CGRect frame = CGRectMake(0,0,_popoverSize,40); //The width may vary depending upon the data we are returning.
        pickerLabel = [[UILabel alloc] initWithFrame:frame];
        [pickerLabel setTextAlignment:UITextAlignmentLeft];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setMinimumFontSize:12.0];
      //[pickerLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
        [pickerLabel setNumberOfLines:0];
        [pickerLabel setText:[[self.pickerOptions objectAtIndex:row] text]];
        return pickerLabel;
    }
    return [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 20)];
}

#pragma mark - Accessibility
-(BOOL)isAccessibilityElement {
    return YES;
}

-(NSString*)accessibilityLabel {
    return @"Single Option Picker";
}

-(void)setPickerOptions:(NSArray *)pickerOptions {
    _pickerOptions = pickerOptions;
}

@end
