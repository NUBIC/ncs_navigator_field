//
//  EventVC.m
//  NCSNavField
//
//  Created by John Dzak on 6/29/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "EventVC.h"
#import "NUScrollView.h"
#import "Event.h"
#import "FormBuilder.h"
#import "PickerOption.h"
#import "TextField.h"
#import "TextArea.h"
#import "DispositionCode.h"

@implementation EventVC

@synthesize event=_event;
@synthesize scrollView=_scrollView;
@synthesize left,right;
- (id)initWithEvent:event {
    if (self = [super init]) {
        _event = event;
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
    NCSLog(@"Event Screen");
    
    CGFloat contactFrameHeight = 580;
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
    
    [self setDefaults:self.event];
    
    left = [self leftEventContentWithFrame:lRect event:self.event];
    left.backgroundColor = [UIColor whiteColor];
    right = [self rightEventContentWithFrame:rRect event:self.event];
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

-(void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:left];
    [[NSNotificationCenter defaultCenter] removeObserver:right];
}

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}


- (void) setDefaults:(Event*)event {
}

# pragma mark - Form

- (UIView*) leftEventContentWithFrame:(CGRect)frame event:(Event*)e {
    UIView* v = [[UIView alloc] initWithFrame:frame];
    
    FormBuilder* b = [[FormBuilder alloc] initWithView:v object:e];
    
    [b sectionHeader:[NSString stringWithFormat:@"%@ %@", e.name, @"Event"]];
    
    [b labelWithText:@"Breakoff"];
    [b singleOptionPickerForProperty:@selector(breakOffId) WithPickerOptions:[MdesCode retrieveAllObjectsForListName:@"CONFIRM_TYPE_CL2"]];
        
    [b labelWithText:@"End Date"];
    [b datePickerForProperty:@selector(endDate)];
    
    [b labelWithText:@"End Time"];
    [b timePickerForProperty:@selector(endTime)];
    
    [b labelWithText:@"Disposition Category"];
    [b singleOptionPickerForProperty:@selector(dispositionCategoryId) WithPickerOptions:[DispositionCode allPickerOptionsForDispositionCategories] andPopoverSize:NUPickerVCPopoverSizeLarge];
    
    [b labelWithText:@"Disposition"];
    [b singleOptionPickerForProperty:@selector(dispositionCode) WithPickerOptions:[DispositionCode allPickerOptions] andPopoverSize:NUPickerVCPopoverSizeLarge];
    
    return v;
}

- (UIView*) rightEventContentWithFrame:(CGRect)frame event:(Event*)e {
    UIView* v = [[UIView alloc] initWithFrame:frame];
    
    FormBuilder* b = [[FormBuilder alloc] initWithView:v object:e];
    
    [b sectionHeader:@""];
    
    [b labelWithText:@"Incentive Type"];
    [b singleOptionPickerForProperty:@selector(incentiveTypeId) WithPickerOptions:[MdesCode retrieveAllObjectsForListName:@"INCENTIVE_TYPE_CL1"]];
    
    [b labelWithText:@"Cash Incentive (xx.xx)"];
    [b textFieldForProperty:@selector(incentiveCash) currency:YES];
    
    [b labelWithText:@"Non-Cash Incentive"];
    [b textFieldForProperty:@selector(incentiveNonCash)];
    
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
    [titleLabel setText:@"Event"];
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
        [[NSNotificationCenter defaultCenter] postNotificationName:@"EventVC#done" object:self]; 
    }];
}

- (void) startTransaction {
    NSManagedObjectContext* moc = [RKObjectManager sharedManager].objectStore.managedObjectContextForCurrentThread;
    NSUndoManager* undoManager = [moc undoManager];
    [undoManager beginUndoGrouping];
}

- (void) endTransction {
    NSManagedObjectContext* moc = [RKObjectManager sharedManager].objectStore.managedObjectContextForCurrentThread;
    NSUndoManager* undoManager = [moc undoManager];
    [undoManager endUndoGrouping];
    
}

- (void) commitTransaction {
    [self endTransction];
    NSManagedObjectContext* moc = [RKObjectManager sharedManager].objectStore.managedObjectContextForCurrentThread;
    NSUndoManager* undoManager = [moc undoManager];
    [undoManager removeAllActions];
    
    NSError *error = nil;
    
    if (![moc save:&error]) {
        NCSLog(@"Error saving initiated contact");
    }
    NCSLog(@"Saved Event");
}

- (void) rollbackTransaction {
    [self endTransction];
    NSManagedObjectContext* moc = [RKObjectManager sharedManager].objectStore.managedObjectContextForCurrentThread;
    NSUndoManager* undoManager = [moc undoManager];
    [undoManager undo];
    NCSLog(@"Rolledback event");
}

#pragma mark - Managing Keyboard

// Taken from:
//http://developer.apple.com/library/ios/#documentation/StringsTextFonts/Conceptual/TextAndWebiPhoneOS/KeyboardManagement/KeyboardManagement.html
- (void)registerForKeyboardNotifications {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
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
        CGPoint newPoint = CGPointMake(0.0,(active.frame.origin.y + active.superview.frame.origin.y + height)-kbSize.width);
        [self.scrollView setContentOffset:newPoint animated:YES];
    }    
}


// Called when the UIKeyboardWillHideNotification is sent

- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    //Lets animate it back to (0,0) and allow scrolling.
#warning This is moving the UIPopoverViewController aware from the button that it is supposed to use to make the selection.
    [self.scrollView setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
    
}


@end
