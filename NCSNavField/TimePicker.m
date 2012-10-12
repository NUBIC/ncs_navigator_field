//
//  TimePicker.m
//  NCSNavField
//
//  Created by John Dzak on 4/4/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "TimePicker.h"
#import "NUPickerVC.h"
#import "ChangeHandler.h"

@interface TimePicker ()
- (NSString*) formatTitleUsingDate:(NSDate*)date;
@end

@implementation TimePicker

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
    NSDateFormatter* dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"hh:mm a"];
    return dateFormatter;
}

- (NUPickerVC*) buildPickerVC {
    NUPickerVC* p= [[NUPickerVC alloc] init];
    [p loadView];
    [p viewDidLoad];
    [p setupDelegate:self withTitle:@"Pick a time" date:YES];
    p.contentSizeForViewInPopover = CGSizeMake(384.0, 260.0);
    p.datePicker.datePickerMode = UIDatePickerModeTime;
    if (self.date) {
        p.datePicker.date = self.date;
    }
    return p;
}

- (UIPopoverController*)buildPopoverVCWithPicker:(NUPickerVC*)picker {
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:picker];
    UIPopoverController* popoverVC = [[UIPopoverController alloc] initWithContentViewController: nav];
    popoverVC.delegate = self;
    return popoverVC;
}

- (void)showPicker {
    if (!self.picker) {
        self.picker = [self buildPickerVC];
    }
    if (!self.popover) {
        self.popover = [self buildPopoverVCWithPicker:self.picker];
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
