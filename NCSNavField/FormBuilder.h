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
- (SingleOptionPicker*) singleOptionPickerForProperty:(SEL)property WithPickerOptions:(NSArray*)options;
- (void) datePickerForProperty:(SEL)property;
- (void) timePickerForProperty:(SEL)property;
- (void) textFieldForProperty:(SEL)property numbersOnly:(BOOL)bNumOnly;
-(void)textFieldForProperty:(SEL)property currency:(BOOL)bCurrencyOnly;
- (void) textFieldForProperty:(SEL)property;
- (void) textAreaForProperty:(SEL)property;
-(void)setOptionsForPicker:(NSArray*)options withTag:(NSUInteger)t; //If we need to reset the options that a picker is going to have based on a previous decision, we can call this.
#pragma mark 
#pragma Show and hide controls
-(void)hideControlWithTag:(NSUInteger)t; //Nothing happens when the tag doesn't exist in the subview of self.view. Throw an exception, maybe? Otherwise, the control is immediately hidden with no lag. 
-(void)animateShowingOfControlWithTags:(NSArray*)arr; //animates the showing of a variable number of hidden controls. The array must contain NSUIntegers.

@end
