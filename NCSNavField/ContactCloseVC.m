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
#import "DispositionCode.h"
#import "SingleOptionPicker.h"

@implementation ContactCloseVC

@synthesize contact=_contact;
@synthesize scrollView = _scrollView;
@synthesize dispositionPicker = _dispositionPicker;

- (id)initWithContact:contact {
    if (self = [super init]) {
        self.contact = contact;

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
    NSLog(@"viewDidAppear Size: %@", NSStringFromCGSize(self.view.frame.size));

    CGFloat contactFrameHeight = 850;
    CGFloat eventFrameHeight = 850;
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
    
    UIView* left = [self leftContactContentWithFrame:lRect contact:self.contact];
    left.backgroundColor = [UIColor whiteColor];
    UIView* right = [self rightContactContentWithFrame:rRect contact:self.contact];
    right.backgroundColor = [UIColor whiteColor];
    [scroll addSubview:left];
    [scroll addSubview:right];    

    CGFloat yLoc = contactFrameHeight;
    for (Event* e in self.contact.events) {
        UIView* le = [self leftEventContentWithFrame:CGRectMake(150, yLoc, lRect.size.width, eventFrameHeight) event:e];
        UIView* re = [self rightEventContentWithFrame:CGRectMake(rRect.origin.x, yLoc, rRect.size.width, eventFrameHeight) event:e];
        re.backgroundColor = [UIColor whiteColor];
        le.backgroundColor = [UIColor whiteColor];
        [scroll addSubview:le];
        [scroll addSubview:re];
        
        yLoc += eventFrameHeight;
    }
    
    scroll.backgroundColor = [UIColor colorWithRed:214.0/255.0 green:216.0/255.0 blue:222.0/255.0 alpha:1.0];
    [self.view addSubview:scroll];
    
    [self registerForKeyboardNotifications];
    
    [self registerContactTypeChangeNotification];
    
    [self startTransaction];
}

- (void) registerContactTypeChangeNotification {
    [self.contact addObserver:self forKeyPath:@"typeId" options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self.contact && [keyPath isEqualToString:@"typeId"]) {
        [self.dispositionPicker updatePickerOptions:[DispositionCode pickerOptionsForContactTypeId:self.contact.typeId]];
        self.contact.dispositionId = NULL;
        [self.dispositionPicker clearResponse];
    }
}

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

//- (void) viewDidLoad {
//    [super viewDidLoad];
//    
//    // WARNING: Do not use if you're using self.frame
//    // use viewDidAppear instead 
//}

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
    
    FormBuilder* b = [[[FormBuilder alloc] initWithView:v object:contact] autorelease];
    
    [b sectionHeader:@"Contact"];
    
    [b labelWithText:@"Contact Type"];
    [b singleOptionPickerForProperty:@selector(typeId) WithPickerOptions:[PickerOption contactTypes]];

    [b labelWithText:@"Contact Date"];
    [b datePickerForProperty:@selector(date)];
    
    [b labelWithText:@"Start Time"];
    [b timePickerForProperty:@selector(startTime)];
    
    [b labelWithText:@"End Time"];
    [b timePickerForProperty:@selector(endTime)];
        
    [b labelWithText:@"Who was contacted"];
    [b singleOptionPickerForProperty:@selector(whoContactedId) WithPickerOptions:[PickerOption whoContacted]];
    
    [b labelWithText:@"Who was contacted (Other)"];
    [b textFieldForProperty:@selector(whoContactedOther)];
    
    [b labelWithText:@"Language"];
    [b singleOptionPickerForProperty:@selector(languageId) WithPickerOptions:[PickerOption language]];
    
    [b labelWithText:@"Language (Other)"];
    [b textFieldForProperty:@selector(languageOther)];
    
    [b labelWithText:@"Interpreter"];
    [b singleOptionPickerForProperty:@selector(interpreterId) WithPickerOptions:[PickerOption interpreter]];
    
    [b labelWithText:@"Interpreter (Other)"];
    [b textFieldForProperty:@selector(interpreterOther)];
    
    return v;
}

- (UIView*) rightContactContentWithFrame:(CGRect)frame contact:(Contact*)contact {
    UIView* v = [[UIView alloc] initWithFrame:frame];
    
    FormBuilder* b = [[[FormBuilder alloc] initWithView:v object:contact] autorelease];
    
    [b sectionHeader:@""];
    
    [b labelWithText:@"Location"];
    [b singleOptionPickerForProperty:@selector(locationid) WithPickerOptions:[PickerOption location]];
    
    [b labelWithText:@"Location (Other)"];
    [b textFieldForProperty:@selector(locationOther)];
    
    [b labelWithText:@"Was contact private"];
    [b singleOptionPickerForProperty:@selector(privateId) WithPickerOptions:[PickerOption private]];
    
    [b labelWithText:@"Private Detail"];
    [b textFieldForProperty:@selector(privateDetail)];
    
    [b labelWithText:@"Distance traveled"];
    [b textFieldForProperty:@selector(distanceTraveled)];
    
    [b labelWithText:@"Disposition"];
    self.dispositionPicker = 
        [b singleOptionPickerForProperty:@selector(dispositionId) WithPickerOptions:[DispositionCode pickerOptionsForContactTypeId:self.contact.typeId] andPopoverSize:NUPickerVCPopoverSizeLarge];        
    
    [b labelWithText:@"Comments"];
    [b textAreaForProperty:@selector(comments)];

    return v;
}

- (UIView*) leftEventContentWithFrame:(CGRect)frame event:(Event*)event {
    UIView* v = [[UIView alloc] initWithFrame:frame];
    
    FormBuilder* b = [[[FormBuilder alloc] initWithView:v object:event] autorelease];
    
    [b sectionHeader:[NSString stringWithFormat:@"Event - %@", event.name]];
    
    [b labelWithText:@"Event Type"];
    [b singleOptionPickerForProperty:@selector(eventTypeId) WithPickerOptions:[PickerOption eventTypes]];
    
    [b labelWithText:@"Event Type (Other)"];
    [b textFieldForProperty:@selector(eventTypeOther)];
    
    [b labelWithText:@"Repeat Key"];
    [b textFieldForProperty:@selector(repeatKey)];
    
    [b labelWithText:@"Start Date"];
    [b datePickerForProperty:@selector(startDate)];
    
    [b labelWithText:@"Start Time"];
    [b timePickerForProperty:@selector(startTime)];
    
    [b labelWithText:@"End Date"];
    [b datePickerForProperty:@selector(endDate)];

    [b labelWithText:@"End Time"];
    [b timePickerForProperty:@selector(endTime)];
    
    [b labelWithText:@"Incentive Type"];
    [b singleOptionPickerForProperty:@selector(incentiveTypeId) WithPickerOptions:[PickerOption incentives]];
    
    [b labelWithText:@"Incentive (Cash)"];
    [b textFieldForProperty:@selector(incentiveCash)];
    
    [b labelWithText:@"Incentive (Non-Cash)"];
    [b textFieldForProperty:@selector(incentiveNonCash)];
    
    return v;
}


- (UIView*) rightEventContentWithFrame:(CGRect)frame event:(Event*)event{
    UIView* v = [[UIView alloc] initWithFrame:frame];
    
    FormBuilder* b = [[[FormBuilder alloc] initWithView:v object:event] autorelease];

    [b sectionHeader:@""];
    
    [b labelWithText:@"Disposition"];
    [b singleOptionPickerForProperty:@selector(dispositionId) WithPickerOptions:[DispositionCode pickerOptionsForContactTypeId:self.contact.typeId] andPopoverSize:NUPickerVCPopoverSizeLarge];

    [b labelWithText:@"Disposition Category"];
    [b singleOptionPickerForProperty:@selector(dispositionCategoryId) WithPickerOptions:[PickerOption dispositionCategory]];     
    
    [b labelWithText:@"Breakoff"];
    [b singleOptionPickerForProperty:@selector(breakoffId) WithPickerOptions:[PickerOption breakoff]];     

    
    [b labelWithText:@"Comments"];
    [b textAreaForProperty:@selector(comments)];

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
    [self dismissViewControllerAnimated:NO completion:^{
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
    NSLog(@"Initialiated contact: %@", self.contact);
}

- (void) rollbackTransaction {
    [self endTransction];
    NSManagedObjectContext* moc = [self.contact managedObjectContext];
    NSUndoManager* undoManager = [moc undoManager];
    [undoManager undo];
    NSLog(@"Rolledback contact: %@", self.contact);
}

#pragma mark - Managing Keyboard

// Taken from:
//http://developer.apple.com/library/ios/#documentation/StringsTextFonts/Conceptual/TextAndWebiPhoneOS/KeyboardManagement/KeyboardManagement.html
- (void)registerForKeyboardNotifications

{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWasShown:)
     
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillBeHidden:)
     
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    
    
}

- (void)keyboardWasShown:(NSNotification*)aNotification {
    TextField* active = [TextField activeField];

    if (active) {
        NSDictionary* info = [aNotification userInfo];
        
        CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
        
        [self.scrollView setContentOffset:CGPointMake(0.0, (active.frame.origin.y + active.superview.frame.origin.y + 80)-kbSize.width) animated:YES];

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
