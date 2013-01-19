//
//  ContactUpdateVC.m
//  NCSNavField
//
//  Created by John Dzak on 12/4/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ContactCloseVC.h"
#import "PickerOption.h"
#import "FormBuilder.h"
#import "NUScrollView.h"
#import "Contact.h"
#import "Event.h"
#import "TextField.h"
#import "SingleOptionPicker.h"
#import "TextArea.h"
#import "DispositionCode.h"
#import "NSManagedObject+ActiveRecord.h"

NSUInteger const DISPOSITION_CATEGORY_TAG = 150;
NSUInteger const DISPOSITION_CODE_TAG_LABEL_2 = 110;
NSUInteger const DISPOSITION_CODE_TAG_PICKER_2 = 99;
NSUInteger const CONTACT_METHOD_TAG = 10;


@implementation ContactCloseVC

@synthesize contact=_contact;
@synthesize scrollView = _scrollView;
@synthesize left,right;
@synthesize leftFormBuilder=_leftFormBuilder,rightFormBuilder=_rightFormBuilder;
@synthesize selectedValueForCategory = _selectedValueForCategory;


- (id)initWithContact:contact {
    if (self = [super init]) {
        _contact = contact;

    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"Close contact screen");

    CGFloat contactFrameHeight = 850;
    CGPoint o = self.view.frame.origin;
//    CGSize s = self.view.frame.size;
    CGFloat width = UIDeviceOrientationIsPortrait(self.interfaceOrientation) ? self.view.frame.size.width : self.view.frame.size.height;
    CGFloat height = UIDeviceOrientationIsPortrait(self.interfaceOrientation) ? self.view.frame.size.height : self.view.frame.size.width;
    
//    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    UIView* toolbar = [self toolbarWithFrame:CGRectMake(0, -2, width, 52)];
    [self.view addSubview:toolbar];
    
    /* Left and Right Pane */
    CGRect rect = CGRectMake(o.x, o.y + 50, width, height - 50 );
    UIScrollView* scroll = [[NUScrollView alloc] initWithFrame:rect];
    self.scrollView = scroll;
    
    CGRect lRect, rRect;
    
    CGRectDivide(CGRectMake(150, 0, width-300, contactFrameHeight), &rRect, &lRect, (width-300) / 2, CGRectMaxXEdge);
    
    [self startTransaction];

    [self setDefaults:self.contact];
    
    left = [self leftContactContentWithFrame:lRect contact:self.contact];
    left.backgroundColor = [UIColor whiteColor];
    right = [self rightContactContentWithFrame:rRect contact:self.contact];
    right.backgroundColor = [UIColor whiteColor];
    [scroll addSubview:left];
    [scroll addSubview:right];    

    scroll.backgroundColor = [UIColor colorWithRed:214.0/255.0 green:216.0/255.0 blue:222.0/255.0 alpha:1.0];
    [self.view addSubview:scroll];
    
//    [left registerForPopoverNotifications];
//    [right registerForPopoverNotifications];
    
//    [self.view registerForPopoverNotifications];
    [self registerForKeyboardNotifications];
}

-(void)viewDidDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self.view];
    [[NSNotificationCenter defaultCenter] removeObserver:left];
    [[NSNotificationCenter defaultCenter] removeObserver:right];
}

- (void) setDefaults:(Contact*)contact {
    if (!contact.languageId || [contact.languageId intValue] == -4) {
        contact.languageId = [NSNumber numberWithInt:1];
    }
    contact.selectedValueForCategory = [Contact dispositionCodeFromContactTypeId:contact.typeId];
    
    if([contact whichSpecialCase]) {
        _isDispositionCategoryLocked=YES;
        _whereToGetDispositionCategory = @selector(whichSpecialCase);
    }
    else {
        _isDispositionCategoryLocked=YES;
        _whereToGetDispositionCategory = @selector(selectedValueForCategory);
    
    }
}

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

- (void) viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

#pragma mark - Form

- (UIView*) leftContactContentWithFrame:(CGRect)frame contact:(Contact*)contact {
    UIView* v = [[UIView alloc] initWithFrame:frame];
    
    _leftFormBuilder = [[FormBuilder alloc] initWithView:v object:contact];
    
    [_leftFormBuilder sectionHeader:@"Contact"];
    
    [_leftFormBuilder labelWithText:@"Contact Date"];
    [_leftFormBuilder datePickerForProperty:@selector(date)];
    
    [_leftFormBuilder labelWithText:@"Contact Start Time"];
    [_leftFormBuilder timePickerForProperty:@selector(startTime)];
    
    [_leftFormBuilder labelWithText:@"Contact End Time"];
    [_leftFormBuilder timePickerForProperty:@selector(endTime)];
        
    [_leftFormBuilder labelWithText:@"Person Contacted"];
    [_leftFormBuilder singleOptionPickerForProperty:@selector(whoContactedId) WithPickerOptions:[MdesCode retrieveAllObjectsForListName:@"CONTACTED_PERSON_CL1"]];

    [_leftFormBuilder labelWithText:@"Person Contacted (Other)"];
    [_leftFormBuilder textFieldForProperty:@selector(whoContactedOther)];
    
    [_leftFormBuilder labelWithText:@"Contact Method"];
    SingleOptionPicker *picker = [_leftFormBuilder singleOptionPickerForProperty:@selector(typeId) WithPickerOptions:[MdesCode retrieveAllObjectsForListName:@"CONTACT_TYPE_CL1"]];
    picker.singleOptionPickerDelegate = self;
    picker.tag = CONTACT_METHOD_TAG;
    
    [_leftFormBuilder labelWithText:@"Location"];
    [_leftFormBuilder singleOptionPickerForProperty:@selector(locationId) WithPickerOptions:[MdesCode retrieveAllObjectsForListName:@"CONTACT_LOCATION_CL1"]];
    
    [_leftFormBuilder labelWithText:@"Location (Other)"];
    [_leftFormBuilder textFieldForProperty:@selector(locationOther)];
    
    [_leftFormBuilder labelWithText:@"Were there privacy issues?"];
    [_leftFormBuilder singleOptionPickerForProperty:@selector(privateId) WithPickerOptions:[MdesCode retrieveAllObjectsForListName:@"CONFIRM_TYPE_CL2"]];
    
    [_leftFormBuilder labelWithText:@"What were the privacy issues?"];
    [_leftFormBuilder textFieldForProperty:@selector(privateDetail)];
    
    return v;
}

- (UIView*) rightContactContentWithFrame:(CGRect)frame contact:(Contact*)contact {
    UIView* v = [[UIView alloc] initWithFrame:frame];
    
    _rightFormBuilder = [[FormBuilder alloc] initWithView:v object:contact];
    
    [_rightFormBuilder sectionHeader:@""];
    
    [_rightFormBuilder labelWithText:@"Distance traveled (in miles)"];
    [_rightFormBuilder textFieldForProperty:@selector(distanceTraveled) numbersOnly:YES];
    
    [_rightFormBuilder labelWithText:@"Disposition Category"];
    SingleOptionPicker *picker = [_rightFormBuilder singleOptionPickerForProperty:_whereToGetDispositionCategory WithPickerOptions:[MdesCode retrieveAllObjectsForListName:@"EVENT_DSPSTN_CAT_CL1"] andTag:DISPOSITION_CATEGORY_TAG];
    picker.singleOptionPickerDelegate = self;
    
    NSString *strPickedCategory = (picker.hasValue) ? picker.text : nil;
    if(_isDispositionCategoryLocked) {
        NSAssert(picker.hasValue,@"Picker does not have value despite disposition category locked.");
        NSAssert(strPickedCategory,@"Picked category does not have a value despite disposition category locked.");
        picker.userInteractionEnabled = NO;
    }
    
    NSArray *arrDispositionOptions = ([strPickedCategory length]>0) ?
    [DispositionCode pickerOptionsByCategoryCode:strPickedCategory] :
    [NSArray array];
    
    [_rightFormBuilder labelWithText:@"Disposition" andTag:DISPOSITION_CODE_TAG_LABEL_2];
    [_rightFormBuilder singleOptionPickerForProperty:@selector(dispositionCode) WithPickerOptions:arrDispositionOptions andPopoverSize:NUPickerVCPopoverSizeLarge andTag:DISPOSITION_CODE_TAG_PICKER_2];
    
    [_rightFormBuilder labelWithText:@"Language of interview"];
    [_rightFormBuilder singleOptionPickerForProperty:@selector(languageId) WithPickerOptions:[MdesCode retrieveAllObjectsForListName:@"LANGUAGE_CL2"]];
    
    [_rightFormBuilder labelWithText:@"Language of interview (Other)"];
    [_rightFormBuilder textFieldForProperty:@selector(languageOther)];
    
    [_rightFormBuilder labelWithText:@"Interpreter"];
    [_rightFormBuilder singleOptionPickerForProperty:@selector(interpreterId) WithPickerOptions:[MdesCode retrieveAllObjectsForListName:@"TRANSLATION_METHOD_CL3"]];
    
    [_rightFormBuilder labelWithText:@"Interpreter (Other)"];
    [_rightFormBuilder textFieldForProperty:@selector(interpreterOther)];
    
    [_rightFormBuilder labelWithText:@"Comments"];
    [_rightFormBuilder textAreaForProperty:@selector(comments)];
    
    if((![[_rightFormBuilder controlForTag:DISPOSITION_CODE_TAG_PICKER_2] hasValue])&&(picker.userInteractionEnabled))
        [_rightFormBuilder hideControlWithTags:DISPOSITION_CODE_TAG_LABEL_2,DISPOSITION_CODE_TAG_PICKER_2,NSNotFound];

    return v;
}

- (UIView*) toolbarWithFrame:(CGRect)frame {
    UIToolbar* t = [[UIToolbar alloc] initWithFrame:frame];
    t.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    UIBarButtonItem* cancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    
    UIBarButtonItem* flexItem1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:NULL action:NULL];
    
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0 , 11.0f, 200.0f, 21.0f)];
    [titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setTextColor:[UIColor colorWithRed:113.0/255.0 green:120.0/255.0 blue:128.0/255.0 alpha:1.0]];
    [titleLabel setText:@"Close Contact"];
    [titleLabel setTextAlignment:UITextAlignmentCenter];
    UIBarButtonItem *toolBarTitle = [[UIBarButtonItem alloc] initWithCustomView:titleLabel];
    
    UIBarButtonItem* flexItem2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:NULL action:NULL];
    
    UIBarButtonItem* done = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(done)];
    done.width = 100;
    
    NSArray* a = [[NSArray alloc] initWithObjects:cancel, flexItem1, toolBarTitle, flexItem2, done, nil];
    [t setItems:a];
    return t;
}

- (void) cancel {
    [self rollbackTransaction];
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void) done {
    [self commitTransaction];
    [self.presentingViewController dismissViewControllerAnimated:NO completion:^{
       [[NSNotificationCenter defaultCenter] postNotificationName:@"ContactClosed" object:self]; 
    }];
}

- (void) startTransaction {
    NSManagedObjectContext* moc = [self.contact managedObjectContext];
    NSUndoManager* undoManager = [moc undoManager];
    [undoManager beginUndoGrouping];
}

- (void) endTransction {
    NSManagedObjectContext* moc = [self.contact managedObjectContext];
    NSUndoManager* undoManager = [moc undoManager];
    [undoManager endUndoGrouping];
    
}

- (void) commitTransaction {
    self.contact.initiated = YES;
    
    [self endTransction];
    NSManagedObjectContext* moc = [self.contact managedObjectContext];
    NSUndoManager* undoManager = [moc undoManager];
    [undoManager removeAllActions];
    
    NSError *error = nil;
    
    if (![moc save:&error]) {
        NSLog(@"Error saving initiated contact");
    }
    NSLog(@"Saved contact: %@", self.contact.contactId);
}

- (void) rollbackTransaction {
    [self endTransction];
    NSManagedObjectContext* moc = [self.contact managedObjectContext];
    NSUndoManager* undoManager = [moc undoManager];
    [undoManager undo];
    NSLog(@"Rolledback contact: %@", self.contact.contactId);
}

#pragma mark - SingleOptionPickerDelegate

-(void)selectionWasMade:(NSString*)str onPicker:(SingleOptionPicker*)pick withValue:(NSUInteger)val {
    
    SingleOptionPicker *dCategoryPicker = (SingleOptionPicker*)[_rightFormBuilder.view viewWithTag:DISPOSITION_CATEGORY_TAG];
    SingleOptionPicker *dCodePicker = (SingleOptionPicker*)[_rightFormBuilder.view viewWithTag:DISPOSITION_CODE_TAG_PICKER_2];
    
    if(pick.tag == CONTACT_METHOD_TAG) {
        //See change #2958
        //based on the selection, we need to lock down the disposition category and populate
        //the disposition code single option picker.
        _contact.selectedValueForCategory = [Contact findDispositionCode:str];
        
        if([_contact whichSpecialCase])
            return;
        
        if([_contact.selectedValueForCategory isEqualToNumber:[NSNumber numberWithInt:5]])
            str = @"Telephone Interview Events"; 
        else if([_contact.selectedValueForCategory isEqualToNumber:[NSNumber numberWithInt:6]])
            str = @"Internet Survey Events"; 
        else if([_contact.selectedValueForCategory isEqualToNumber:[NSNumber numberWithInt:4]])
            str = @"Mailed Back Self Administered Questionnaires"; 
        else if([_contact.selectedValueForCategory isEqualToNumber:[NSNumber numberWithInt:3]])
            str = @"General Study Visits (including CASI SAQs)"; 
        
        _whereToGetDispositionCategory = @selector(selectedValueForCategory);
        [dCategoryPicker setUserInteractionEnabled:NO];
        [dCategoryPicker setValue:_contact.selectedValueForCategory forKey:@"value"];
        [dCategoryPicker updatePicker];
    }
    //This is being called when the disposition category is selected.
    NSAssert([str length]>0,@"We should have a category disposition name to get the codes in Contact");
    [dCodePicker clearResponse];
    [dCodePicker updatePickerOptions:[DispositionCode pickerOptionsByCategoryCode:str]];
    [_rightFormBuilder animateShowingOfControlWithTags:DISPOSITION_CODE_TAG_LABEL_2,DISPOSITION_CODE_TAG_PICKER_2,NSNotFound];
}

#pragma mark - Managing Keyboard

// Taken from:
//http://developer.apple.com/library/ios/#documentation/StringsTextFonts/Conceptual/TextAndWebiPhoneOS/KeyboardManagement/KeyboardManagement.html
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWasShown:(NSNotification*)aNotification {
    NSInteger height = 80;
    UIView* active = [TextField activeField];
    if (!active) {
        active = [TextArea activeField];
        height += 140;
    }
    if (active) {
        NSDictionary* info = [aNotification userInfo];
        CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
        [self.scrollView setContentOffset:CGPointMake(0.0, (active.frame.origin.y + active.superview.frame.origin.y + height)-kbSize.width) animated:YES];

    }    
}



// Called when the UIKeyboardWillHideNotification is sent

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}


@end
