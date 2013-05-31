//
//  FormBuilder.h
//  NCSNavField
//
//  Created by John Dzak on 12/4/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIView+Additions.h"
#import "SingleOptionPicker.h"

#define DEFAULT_WIDTH 240
#define DEFAULT_HEIGHT 30

@class FormBuilderCursor;

@class TimePicker, DatePicker, TextArea, TextField;

@interface FormBuilder : NSObject {
    UIView* _view;
    id _object;
    FormBuilderCursor* _cursor;
}

@property(nonatomic,strong)UIView* view;
@property(nonatomic,strong)id object;
@property(nonatomic,strong)FormBuilderCursor* cursor;

- (id) initWithView:(UIView*)view object:(id)obj;

// Builder methods
- (FormBuilder*) fieldsForObject:(id)object;
- (void) sectionHeader:(NSString*)text;
- (void)labelWithText:(NSString*)text;
- (void)labelWithText:(NSString*)text andTag:(NSUInteger)t; //If we want to do something dynamic with it, we must provide a tag. 
- (SingleOptionPicker*) singleOptionPickerForProperty:(SEL)property WithPickerOptions:(NSArray*)options andPopoverSize:(NUPickerVCPopoverSize)popoverSize;
//If we want to do something dynamic with it, we must provide a tag. 
- (SingleOptionPicker*) singleOptionPickerForProperty:(SEL)property WithPickerOptions:(NSArray*)options andPopoverSize:(NUPickerVCPopoverSize)popoverSize andTag:(NSUInteger)t;
- (SingleOptionPicker*) singleOptionPickerForProperty:(SEL)property WithPickerOptions:(NSArray*)options andTag:(NSUInteger)t;
- (SingleOptionPicker*) singleOptionPickerForProperty:(SEL)property WithPickerOptions:(NSArray*)options;
- (DatePicker *) datePickerForProperty:(SEL)property;
- (TimePicker *) timePickerForProperty:(SEL)property;
- (TextField *) textFieldForProperty:(SEL)property numbersOnly:(BOOL)bNumOnly;
-(TextField *)textFieldForProperty:(SEL)property currency:(BOOL)bCurrencyOnly;
- (TextField *) textFieldForProperty:(SEL)property;
- (TextArea *) textAreaForProperty:(SEL)property;

-(void)resetRequiredFormElements;
-(void)warnFormElementsWithProperties:(NSArray *)requiredProperties;

#pragma mark 
#pragma Show and hide controls
- (id)controlForTag:(NSUInteger)t;
-(void)hideControlWithTag:(NSUInteger)t; //Nothing happens when the tag doesn't exist in the subview of self.view. Throw an exception, maybe? Otherwise, the control is immediately hidden with no lag.
-(void)hideControlWithTags:(NSUInteger)s,...; //Must end with a NSNotFound.
-(void)animateShowingOfControlWithTags:(NSUInteger)s,...; //animates the showing of a variable number of hidden controls. The array must contain NSUIntegers.
-(void)showSubviewHierarchy;
@end
