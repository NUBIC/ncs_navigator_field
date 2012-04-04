//
//  DatePickerButton.m
//  NCSNavField
//
//  Created by John Dzak on 12/2/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DatePicker.h"
#import "NUPickerVC.h"
#import "ChangeHandler.h"

@interface DatePicker ()
- (NSString*) formatTitleUsingDate:(NSDate*)date;
@end

@implementation DatePicker

@synthesize date = _date;
@synthesize button = _button;
@synthesize picker = _picker;
@synthesize popover = _popover;
@synthesize handler = _handler;
@synthesize dateFormatter = _dateFormatter;

- (id)initWithFrame:(CGRect)frame value:(NSDate*)value {
    self = [super initWithFrame:frame];
    if (self) {
        // Create button
        self.button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.button.frame = CGRectMake(0, 0, 200, 30);
        [self.button setTitle:[self formatTitleUsingDate:value] forState:UIControlStateNormal];
        
        // Setup button target
        [self.button addTarget:self action:@selector(showPicker) forControlEvents:UIControlEventTouchUpInside];
        
        self.date = value;

        [self addSubview:self.button];
    }
    return self;
}

- (void) addChangeHandler:(ChangeHandler*)handler {
    self.handler = handler;
}

- (NSString*) formatTitleUsingDate:(NSDate*)date {
    return date ? [self.dateFormatter stringFromDate:date] : @"Pick One";
}

- (NSDateFormatter*) getDateFormatter {
    NSDateFormatter* dateFormatter = [[NSDateFormatter new] autorelease];
    [dateFormatter setDateFormat:@"MMMM dd"];
    return dateFormatter;
}

- (NUPickerVC*) initPickerVC {
    NUPickerVC* p= [[[NUPickerVC alloc] init] autorelease];
    [p loadView];
    [p viewDidLoad];
    [p setupDelegate:self withTitle:@"Pick a date" date:YES];
    p.contentSizeForViewInPopover = CGSizeMake(384.0, 260.0);
    p.datePicker.datePickerMode = UIDatePickerModeDate;
    if (self.date) {
        p.datePicker.date = self.date;
    }
    return p;
}

- (UIPopoverController*)initPopoverVCWithPicker:(NUPickerVC*)picker {
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:picker];
    UIPopoverController* popoverVC = [[UIPopoverController alloc] initWithContentViewController: nav];
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

- (void) nowPressed{
    [self.picker.datePicker setDate:[NSDate date] animated:YES];
    [self performSelector:@selector(pickerDone) withObject:nil afterDelay:0.4];
	//  [self  pickerDone];  
}

- (void) pickerDone{
    [self.popover dismissPopoverAnimated:NO];
    NSDate* d = [self.picker.datePicker date]; 
    self.date = d;
    [self.handler updatedValue:d];
    [self.button setTitle:[self formatTitleUsingDate:d] forState:UIControlStateNormal];
        
//        [delegate deleteResponseForIndexPath:[self myIndexPathWithRow:selectedRow]];
//        [delegate newResponseForIndexPath:[self myIndexPathWithRow:selectedRow]];
//        [delegate showAndHideDependenciesTriggeredBy:[self myIndexPathWithRow:selectedRow]];
//        self.textLabel.text = [(NSDictionary *)[answers objectAtIndex:selectedRow] objectForKey:@"text"];
//        self.textLabel.textColor = RGB(1, 113, 233);
}
- (void) pickerCancel{
    if (self.date) {
        self.picker.datePicker.date = self.date;
    }
    [self.popover dismissPopoverAnimated:NO];
}

@end
