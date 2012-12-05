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
- (id)controlForTag:(NSUInteger)t;
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

- (void)labelWithText:(NSString*)text {
    UILabel* l = [[UILabel alloc] initWithFrame:CGRectMake(self.cursor.x, self.cursor.y, DEFAULT_WIDTH, DEFAULT_HEIGHT)];
    l.text = text;
    l.backgroundColor = [UIColor colorWithRed: 1.0 green: 1.0 blue: 1.0 alpha:0.0];
    [self.view addSubview:l];
    [self.cursor addNewLine];
}

- (void)labelWithText:(NSString*)text andTag:(NSUInteger)t {
    UILabel* l = [[UILabel alloc] initWithFrame:CGRectMake(self.cursor.x, self.cursor.y, DEFAULT_WIDTH, DEFAULT_HEIGHT)];
    l.tag = t;
    l.text = text;
    l.backgroundColor = [UIColor colorWithRed: 1.0 green: 1.0 blue: 1.0 alpha:0.0];
    [self.view addSubview:l];
    [self.cursor addNewLine];
}

- (SingleOptionPicker*) singleOptionPickerForProperty:(SEL)property WithPickerOptions:(NSArray*)options andPopoverSize:(NUPickerVCPopoverSize)popoverSize andTag:(NSUInteger)t {
    SingleOptionPicker* b = [self singleOptionPickerForProperty:property WithPickerOptions:options andPopoverSize:popoverSize];
    b.tag = t;
    return b;
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

- (void)textFieldForProperty:(SEL)property numbersOnly:(BOOL)bNumOnly {
    
    if(!bNumOnly) {
        [self textFieldForProperty:property];
    }
    else {
        TextField* t = [[TextField alloc] initWithFrame:CGRectMake(self.cursor.x, self.cursor.y, DEFAULT_WIDTH, DEFAULT_HEIGHT) value:[self objectValueForKey:property] numbersOnly:YES];
        [t addChangeHandler:[[ChangeHandler alloc] initWithObject:self.object field:property]];
        [self.view addSubview:t];
        [self.cursor addNewLine];
    }
}

-(void)textFieldForProperty:(SEL)property currency:(BOOL)bCurrencyOnly {
    
    TextField* t = [[TextField alloc] initWithFrame:CGRectMake(self.cursor.x, self.cursor.y, DEFAULT_WIDTH, DEFAULT_HEIGHT) value:[self objectValueForKey:property] currencyFormat:YES];
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


#pragma mark - Hide/Show views and re-populate them dynamically.

- (id)controlForTag:(NSUInteger)t
{
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id obj, NSDictionary *bind) {
        return ((UIView*)obj).tag = t;
    }];
    NSArray *oneObjArray = [[self.view subviews] filteredArrayUsingPredicate:predicate];
    return [oneObjArray objectAtIndex:0];
}

-(void)hideControlWithTag:(NSUInteger)t {
    id i = [self controlForTag:t];
    [i setHidden:YES];
}

-(void)setOptionsForPicker:(NSArray*)options withTag:(NSUInteger)t
{
    SingleOptionPicker *p = [self controlForTag:t];
    p.pickerOptions = options;
}

-(void)animateShowingOfControlWithTags:(NSArray*)arr {
    for(int i=0;i<[arr count];i++) {
        [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionTransitionNone
                         animations:^(void) { [[self controlForTag:(NSUInteger)[arr objectAtIndex:i]] setHidden:NO]; } completion:nil];
    }
}

- (id) objectValueForKey:(SEL)key {
    return [_object respondsToSelector:key] ? [_object performSelector:key] : NULL;
}


@end
