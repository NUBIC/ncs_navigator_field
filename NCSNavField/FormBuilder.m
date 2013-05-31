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

@property (nonatomic, strong) NSDictionary *requiredFormElementsDictionary;

@end
    
@implementation FormBuilder

@synthesize view=_view;
@synthesize object=_object;
@synthesize cursor=_cursor;

-(void)resetRequiredFormElements {
    for (id requiredFormElement in self.requiredFormElementsDictionary.allValues) {
        [(id<FormElementProtocol>)requiredFormElement resetMarkAsRequired];
    }
}

-(void)warnFormElementsWithProperties:(NSArray *)requiredProperties {
    for (NSString *requiredProperty in requiredProperties) {
        if ([self.requiredFormElementsDictionary valueForKey:requiredProperty]) {
            [(id<FormElementProtocol>)[self.requiredFormElementsDictionary valueForKey:requiredProperty] markAsRequired];
        }
    }
}

-(void)checkFormElement:(id)formElement withPropertyString:(NSString *)propertyString {
    NSDictionary *mutableRequiredFormDictionary = [self.requiredFormElementsDictionary mutableCopy];
    if ([self.object respondsToSelector:@selector(requiredProperties)]) {
        for (NSString *requiredProperty in [self.object performSelector:@selector(requiredProperties)]) {
            if ([propertyString isEqualToString:requiredProperty]) {
                [mutableRequiredFormDictionary setValue:formElement forKey:requiredProperty];
            }
        }
    }
    self.requiredFormElementsDictionary = [NSDictionary dictionaryWithDictionary:mutableRequiredFormDictionary];
}

- (id) initWithView:(UIView*)view object:(id)obj {
    if (self = [super init]) {
        self.view = view;
        self.object = obj;
        self.cursor = [FormBuilderCursor new];
        self.requiredFormElementsDictionary = @{};
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
    SingleOptionPicker *b = [self singleOptionPickerForProperty:property WithPickerOptions:options andPopoverSize:popoverSize];
    b.tag = t;
    [self checkFormElement:b withPropertyString:NSStringFromSelector(property)];
    return b;
}

- (SingleOptionPicker*) singleOptionPickerForProperty:(SEL)property WithPickerOptions:(NSArray*)options andPopoverSize:(NUPickerVCPopoverSize)popoverSize {
    SingleOptionPicker* b = [[SingleOptionPicker alloc] initWithFrame:CGRectMake(self.cursor.x, self.cursor.y, DEFAULT_WIDTH, DEFAULT_HEIGHT) value:(NSNumber*)[self objectValueForKey:property] pickerOptions:options popoverSize:popoverSize];
    [b addChangeHandler:[[ChangeHandler alloc] initWithObject:self.object field:property]];
    [self.view addSubview:b];
    [self.cursor addNewLine];
    [self checkFormElement:b withPropertyString:NSStringFromSelector(property)];
    return b;
}

- (SingleOptionPicker*) singleOptionPickerForProperty:(SEL)property WithPickerOptions:(NSArray*)options andTag:(NSUInteger)t {
    SingleOptionPicker* b = [self singleOptionPickerForProperty:property WithPickerOptions:options];
    b.tag = t;
    [self checkFormElement:b withPropertyString:NSStringFromSelector(property)];
    return b;
}

- (SingleOptionPicker*) singleOptionPickerForProperty:(SEL)property WithPickerOptions:(NSArray*)options {
    SingleOptionPicker *b = [self singleOptionPickerForProperty:property WithPickerOptions:options andPopoverSize:NUPickerVCPopoverSizeRegular];
    [self checkFormElement:b withPropertyString:NSStringFromSelector(property)];
    return b;
}

- (DatePicker *) datePickerForProperty:(SEL)property {
    DatePicker* b = [[DatePicker alloc] initWithFrame:CGRectMake(self.cursor.x, self.cursor.y, DEFAULT_WIDTH, DEFAULT_HEIGHT) value:[self objectValueForKey:property]];
    [b addChangeHandler:[[ChangeHandler alloc] initWithObject:self.object field:property]];
    [self.view addSubview:b];
    [self.cursor addNewLine];
    [self checkFormElement:b withPropertyString:NSStringFromSelector(property)];
    return b;
}

- (TimePicker *) timePickerForProperty:(SEL)property {
    TimePicker* t = [[TimePicker alloc] initWithFrame:CGRectMake(self.cursor.x, self.cursor.y, DEFAULT_WIDTH, DEFAULT_HEIGHT) value:[self objectValueForKey:property]];
    [t addChangeHandler:[[ChangeHandler alloc] initWithObject:self.object field:property]];
    [self.view addSubview:t];
    [self.cursor addNewLine];
    [self checkFormElement:t withPropertyString:NSStringFromSelector(property)];
    return t;
}

- (TextField *)textFieldForProperty:(SEL)property numbersOnly:(BOOL)bNumOnly {
    
    if(!bNumOnly) {
        TextField *t = [self textFieldForProperty:property];
        [self checkFormElement:t withPropertyString:NSStringFromSelector(property)];
        return t;
    }
    else {
        TextField* t = [[TextField alloc] initWithFrame:CGRectMake(self.cursor.x, self.cursor.y, DEFAULT_WIDTH, DEFAULT_HEIGHT) value:[self objectValueForKey:property] numbersOnly:YES];
        [t addChangeHandler:[[ChangeHandler alloc] initWithObject:self.object field:property]];
        [self.view addSubview:t];
        [self.cursor addNewLine];
        [self checkFormElement:t withPropertyString:NSStringFromSelector(property)];
        return t;
    }
}

-(TextField *)textFieldForProperty:(SEL)property currency:(BOOL)bCurrencyOnly {
    TextField* t = [[TextField alloc] initWithFrame:CGRectMake(self.cursor.x, self.cursor.y, DEFAULT_WIDTH, DEFAULT_HEIGHT) value:[self objectValueForKey:property] currencyFormat:YES];
    [t addChangeHandler:[[ChangeHandler alloc] initWithObject:self.object field:property]];
    [self.view addSubview:t];
    [self.cursor addNewLine];
    [self checkFormElement:t withPropertyString:NSStringFromSelector(property)];
    return t;
}

- (TextField *) textFieldForProperty:(SEL)property {
    TextField* t = [[TextField alloc] initWithFrame:CGRectMake(self.cursor.x, self.cursor.y, DEFAULT_WIDTH, DEFAULT_HEIGHT) value:[self objectValueForKey:property]];
    [t addChangeHandler:[[ChangeHandler alloc] initWithObject:self.object field:property]];
    [self.view addSubview:t];
    [self.cursor addNewLine];
    [self checkFormElement:t withPropertyString:NSStringFromSelector(property)];
    return t;
}

- (TextArea *) textAreaForProperty:(SEL)property {
    TextArea* t = [[TextArea alloc] initWithFrame:CGRectMake(self.cursor.x, self.cursor.y, DEFAULT_WIDTH, 200) value:[self objectValueForKey:property]];
    [t addChangeHandler:[[ChangeHandler alloc] initWithObject:self.object field:property]];
    [self.view addSubview:t];
    [self.cursor addNewLine];
    [self checkFormElement:t withPropertyString:NSStringFromSelector(property)];
    return t;
}

#pragma mark - Hide/Show views and re-populate them dynamically.

-(void)showSubviewHierarchy {
    [self.view dumpViews:@"" indent:@"--"];
}

- (id)controlForTag:(NSUInteger)t
{
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id obj, NSDictionary *bind) {
        return (((UIView*)obj).tag == t);
    }];
    NSArray *oneObjArray = [[self.view subviews] filteredArrayUsingPredicate:predicate];
    return [oneObjArray lastObject];
}

-(void)hideControlWithTag:(NSUInteger)t {
    NSAssert([NSThread mainThread],@"hideControlWithTag updates the UI and therefore must be called from the main thread.");
    id i = [self controlForTag:t];
    if([i respondsToSelector:@selector(setAlpha:)])
    {
        [i setAlpha:0.0f];
    }
}

-(void)hideControlWithTags:(NSUInteger)s,... {
   
    va_list args;
    va_start(args, s);
    for (int i = s; i != NSNotFound; i = va_arg(args, NSUInteger))
    {
        [UIView animateWithDuration:1 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             [[self controlForTag:i] setAlpha:0];
                         }
                         completion:nil];

    }
    va_end(args);
}

-(void)animateShowingOfControlWithTags:(NSUInteger)s,... {
    va_list args;
    va_start(args, s);
    for (int i = s; i != NSNotFound; i = va_arg(args, NSUInteger))
    {
        [UIView animateWithDuration:1 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             [[self controlForTag:i] setAlpha:1];
                         }
                         completion:nil];
        
    }
    va_end(args);
}

- (id) objectValueForKey:(SEL)key {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks" //http://stackoverflow.com/questions/7017281/performselector-may-cause-a-leak-because-its-selector-is-unknown
    return [_object respondsToSelector:key] ? [_object performSelector:key] : NULL;
#pragma clang diagnostic pop
}


@end
