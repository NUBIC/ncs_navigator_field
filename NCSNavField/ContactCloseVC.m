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

@implementation ContactCloseVC

@synthesize contact=_contact;
@synthesize scrollView = _scrollView;
@synthesize dispositionPicker = _dispositionPicker;
@synthesize left,right;

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
    NCSLog(@"Close contact screen");

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
    
    [left registerForPopoverNotifications];
    [right registerForPopoverNotifications];
    
    [self.view registerForPopoverNotifications];
    [self registerForKeyboardNotifications];
    [self registerContactTypeChangeNotification];
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
}

- (void) registerContactTypeChangeNotification {
    [self.contact addObserver:self forKeyPath:@"typeId" options:NSKeyValueObservingOptionNew context:NULL];
}

- (void) unregisterContactTypeChangeNotification {
    [self.contact removeObserver:self forKeyPath:@"typeId"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self.contact && [keyPath isEqualToString:@"typeId"]) {
        // FIX: Commented out to fix the build
//        [self.dispositionPicker updatePickerOptions:[DispositionCode pickerOptionsForContactTypeId:self.contact.typeId]];
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
    
    FormBuilder* b = [[FormBuilder alloc] initWithView:v object:contact];
    
    [b sectionHeader:@"Contact"];
    
    [b labelWithText:@"Contact Date"];
    [b datePickerForProperty:@selector(date)];
    
    [b labelWithText:@"Contact Start Time"];
    [b timePickerForProperty:@selector(startTime)];
    
    [b labelWithText:@"Contact End Time"];
    [b timePickerForProperty:@selector(endTime)];
        
    [b labelWithText:@"Person Contacted"];
    [b singleOptionPickerForProperty:@selector(whoContactedId) WithPickerOptions:[MdesCode retrieveAllObjectsForListName:@"CONTACTED_PERSON_CL1"]];

    [b labelWithText:@"Person Contacted (Other)"];
    [b textFieldForProperty:@selector(whoContactedOther)];
    
    [b labelWithText:@"Contact Method"];
    [b singleOptionPickerForProperty:@selector(typeId) WithPickerOptions:[MdesCode retrieveAllObjectsForListName:@"CONTACT_TYPE_CL1"]];
    
    [b labelWithText:@"Location"];
    [b singleOptionPickerForProperty:@selector(locationId) WithPickerOptions:[MdesCode retrieveAllObjectsForListName:@"CONTACT_LOCATION_CL1"]];
    
    [b labelWithText:@"Location (Other)"];
    [b textFieldForProperty:@selector(locationOther)];
    
    [b labelWithText:@"Were there privacy issues?"];
    [b singleOptionPickerForProperty:@selector(privateId) WithPickerOptions:[MdesCode privateList]];
    
    [b labelWithText:@"What were the privacy issues?"];
    [b textFieldForProperty:@selector(privateDetail)];
    
    return v;
}

- (UIView*) rightContactContentWithFrame:(CGRect)frame contact:(Contact*)contact {
    UIView* v = [[UIView alloc] initWithFrame:frame];
    
    FormBuilder* b = [[FormBuilder alloc] initWithView:v object:contact];
    
    [b sectionHeader:@""];
    
    [b labelWithText:@"Distance traveled (in miles)"];
    [b textFieldForProperty:@selector(distanceTraveled) numbersOnly:YES];
    
    [b labelWithText:@"Disposition"];
    // FIX: Commented out to fix the build
//    self.dispositionPicker = 
//    [b singleOptionPickerForProperty:@selector(dispositionId) WithPickerOptions:[DispositionCode pickerOptionsForContactTypeId:self.contact.typeId] andPopoverSize:NUPickerVCPopoverSizeLarge];
    
    [b labelWithText:@"Language of interview"];
    [b singleOptionPickerForProperty:@selector(languageId) WithPickerOptions:[MdesCode retrieveAllObjectsForListName:@"CONTACT_LOCATION_CL1"]];
    
    [b labelWithText:@"Language of interview (Other)"];
    [b textFieldForProperty:@selector(languageOther)];
    
    [b labelWithText:@"Interpreter"];
    [b singleOptionPickerForProperty:@selector(interpreterId) WithPickerOptions:[MdesCode retrieveAllObjectsForListName:@"TRANSLATION_METHOD_CL3"]];
    
    [b labelWithText:@"Interpreter (Other)"];
    [b textFieldForProperty:@selector(interpreterOther)];
    
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
    [self unregisterContactTypeChangeNotification];
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void) done {
    [self commitTransaction];
    [self unregisterContactTypeChangeNotification];
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
        NCSLog(@"Error saving initiated contact");
    }
    NCSLog(@"Saved contact: %@", self.contact.contactId);
}

- (void) rollbackTransaction {
    [self endTransction];
    NSManagedObjectContext* moc = [self.contact managedObjectContext];
    NSUndoManager* undoManager = [moc undoManager];
    [undoManager undo];
    NCSLog(@"Rolledback contact: %@", self.contact.contactId);
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
