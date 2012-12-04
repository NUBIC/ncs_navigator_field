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
#import "NUPickerVC+Additions.h"

@implementation SingleOptionPicker

@synthesize value = _value;

@synthesize button = _button;

@synthesize picker = _picker;

@synthesize popover = _popover;

@synthesize handler = _handler;

@synthesize pickerOptions = _pickerOptions;

@synthesize popoverSize = _popoverSize;

@synthesize widthOfNUPicker=_widthOfNUPicker;

- (id)initWithFrame:(CGRect)frame value:(NSNumber*)value pickerOptions:(NSArray*)options {
    self.accessibilityLabel = @"Single Option Picker";
    self.isAccessibilityElement=YES;
    return [self initWithFrame:frame value:value pickerOptions:options popoverSize:NUPickerVCPopoverSizeRegular];
}
//This will always get called.
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
        //We want something that gives us an array of text from an array of PickerOptions.
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
    PickerOption* title = [PickerOption findWithValue:self.value fromOptions:self.pickerOptions];
    
    //We have the options, lets get the length of the largest string with the given font.
    _widthOfNUPicker = [p calculateNecessaryWidth:[self textSelections] withFont:[UIFont boldSystemFontOfSize:24]];

    p.contentSizeForViewInPopover = [self CGSizeFromPopoverSize:self.popoverSize];

    
    if (title) {
        [self.button setTitle:title.text forState:UIControlStateNormal];
        NSInteger index = [self.pickerOptions indexOfObject:title];
        [p.picker selectRow:index inComponent:0 animated:NO];
    }
    return p;
}
//TODO:We may re-think this. 
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
    PickerOption* p = [self.pickerOptions objectAtIndex:row];
    return p.text; 
}

#pragma mark - Acce ssibility
-(BOOL)isAccessibilityElement {
    return YES;
}

-(NSString*)accessibilityLabel {
    return @"Single Option Picker";
}

-(void)setPickerOptions:(NSArray *)pickerOptions {
    _pickerOptions = pickerOptions;
}
//Override description to tell us about what the options say as well.
-(NSString*)description {
    NSMutableString *str = [[NSMutableString alloc] initWithFormat:@"<PickerOption: %p>\n",self];
    for(PickerOption *o in self.pickerOptions) {
        [str appendString:[o.value description]];
        [str appendString:@" ----- "];
        [str appendString:o.text];
        [str appendString:@"\n"];
    }
    return str;
}

-(NSArray*)textSelections {
    NSMutableArray *arr = [NSMutableArray new];
    
    for(PickerOption *o in self.pickerOptions) {
        [arr addObject:o.text];
    }
    return arr;
    
}

@end
