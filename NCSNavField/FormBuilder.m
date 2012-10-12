//
//  FormBuilder.m
//  NCSNavField
//
//  Created by John Dzak on 12/4/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "FormBuilder.h"
#import "FormBuilderCursor.h"
#import "DatePicker.h"
#import "SingleOptionPicker.h"
#import "ChangeHandler.h"
#import "TextField.h"
#import "TextArea.h"
#import "TimePicker.h"

@interface FormBuilder()
- (id) initWithView:(UIView *)view object:(id)obj cursor:(FormBuilderCursor*)cursor;
- (id) objectValueForKey:(SEL)key;
@end
    
@implementation FormBuilder

@synthesize view=_view;
@synthesize object=_object;
@synthesize cursor=_cursor;

- (id) initWithView:(UIView*)view object:(id)obj {
    if (self = [super init]) {
        self.view = view;
        self.object = obj;
        self.cursor = [FormBuilderCursor new];
    }
    return self;
}

- (id) initWithView:(UIView*)view object:(id)obj cursor:(FormBuilderCursor*)cursor {
    if (self = [super init]) {
        self.view = view;
        self.object = obj;
        self.cursor = cursor;
    }
    return self;
}

- (FormBuilder*) fieldsForObject:(id)object {
    return [[FormBuilder alloc] initWithView:self.view object:object cursor:self.cursor];
}

- (void) sectionHeader:(NSString*)text {
    UILabel* l = [[UILabel alloc] initWithFrame:CGRectMake(2, self.cursor.y, DEFAULT_WIDTH, DEFAULT_HEIGHT)];
    l.text = text;
    l.backgroundColor = [UIColor colorWithRed: 1.0 green: 1.0 blue: 1.0 alpha:0.0];
    l.font = [UIFont boldSystemFontOfSize:18];
    [self.view addSubview:l];
    [self.cursor addNewLine];
    
}

- (void) labelWithText:(NSString*)text {
    UILabel* l = [[UILabel alloc] initWithFrame:CGRectMake(self.cursor.x, self.cursor.y, DEFAULT_WIDTH, DEFAULT_HEIGHT)];
    l.text = text;
    l.backgroundColor = [UIColor colorWithRed: 1.0 green: 1.0 blue: 1.0 alpha:0.0];
    [self.view addSubview:l];
    [self.cursor addNewLine];
}

- (SingleOptionPicker*) singleOptionPickerForProperty:(SEL)property WithPickerOptions:(NSArray*)options andPopoverSize:(NUPickerVCPopoverSize)popoverSize {
    SingleOptionPicker* b = [[SingleOptionPicker alloc] initWithFrame:CGRectMake(self.cursor.x, self.cursor.y, DEFAULT_WIDTH, DEFAULT_HEIGHT) value:(NSNumber*)[self objectValueForKey:property] pickerOptions:options popoverSize:popoverSize];
    [b addChangeHandler:[[ChangeHandler alloc] initWithObject:self.object field:property]];
    [self.view addSubview:b];
    [self.cursor addNewLine];
    return b;
}

- (SingleOptionPicker*) singleOptionPickerForProperty:(SEL)property WithPickerOptions:(NSArray*)options {
    return [self singleOptionPickerForProperty:property WithPickerOptions:options andPopoverSize:NUPickerVCPopoverSizeRegular];
}

- (void) datePickerForProperty:(SEL)property {
    DatePicker* b = [[DatePicker alloc] initWithFrame:CGRectMake(self.cursor.x, self.cursor.y, DEFAULT_WIDTH, DEFAULT_HEIGHT) value:[self objectValueForKey:property]];
    [b addChangeHandler:[[ChangeHandler alloc] initWithObject:self.object field:property]];
    [self.view addSubview:b];
    [self.cursor addNewLine];
}

- (void) timePickerForProperty:(SEL)property {
    TimePicker* t = [[TimePicker alloc] initWithFrame:CGRectMake(self.cursor.x, self.cursor.y, DEFAULT_WIDTH, DEFAULT_HEIGHT) value:[self objectValueForKey:property]];
    [t addChangeHandler:[[ChangeHandler alloc] initWithObject:self.object field:property]];
    [self.view addSubview:t];
    [self.cursor addNewLine];
}

- (void) textFieldForProperty:(SEL)property {
    TextField* t = [[TextField alloc] initWithFrame:CGRectMake(self.cursor.x, self.cursor.y, DEFAULT_WIDTH, DEFAULT_HEIGHT) value:[self objectValueForKey:property]];
    [t addChangeHandler:[[ChangeHandler alloc] initWithObject:self.object field:property]];
    [self.view addSubview:t];
    [self.cursor addNewLine];
}

- (void) textAreaForProperty:(SEL)property {
    TextArea* t = [[TextArea alloc] initWithFrame:CGRectMake(self.cursor.x, self.cursor.y, DEFAULT_WIDTH, 200) value:[self objectValueForKey:property]];
    [t addChangeHandler:[[ChangeHandler alloc] initWithObject:self.object field:property]];
    [self.view addSubview:t];
    [self.cursor addNewLine];
}


- (id) objectValueForKey:(SEL)key {
    return [_object respondsToSelector:key] ? [_object performSelector:key] : NULL;
}


@end
