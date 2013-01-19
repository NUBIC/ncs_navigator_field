//
//  InstrumentVC.m
//  NCSNavField
//
//  Created by John Dzak on 4/17/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "InstrumentVC.h"
#import "FormBuilder.h"
#import "NUScrollView.h"
#import "PickerOption.h"
#import "TextField.h"
#import "TextArea.h"
#import "Instrument.h"

@implementation InstrumentVC

@synthesize instrument=_instrument;
@synthesize scrollView=_scrollView;
@synthesize left,right;

- (id)initWithInstrument:instrument {
    if (self = [super init]) {
        _instrument = instrument;
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
    NSLog(@"Instrument Screen");
    
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

    [self setDefaults:self.instrument];
    
    left = [self leftInstrumentContentWithFrame:lRect contact:self.instrument];
    left.backgroundColor = [UIColor whiteColor];
    right = [self rightInstrumentContentWithFrame:rRect contact:self.instrument];
    right.backgroundColor = [UIColor whiteColor];
    [scroll addSubview:left];
    [scroll addSubview:right];    
        
    scroll.backgroundColor = [UIColor colorWithRed:214.0/255.0 green:216.0/255.0 blue:222.0/255.0 alpha:1.0];
    [self.view addSubview:scroll];
    //[self.view registerForPopoverNotifications];
//    [left registerForPopoverNotifications];
//    [right registerForPopoverNotifications];
    [self registerForKeyboardNotifications];
}

-(void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:left];
    [[NSNotificationCenter defaultCenter] removeObserver:right];
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



- (void) setDefaults:(Instrument*)instrument {
    if (!instrument.statusId || [instrument.statusId intValue] == -4) {
        instrument.statusId = [NSNumber numberWithInt:4];
    }
    
    if (!instrument.breakOffId || [instrument.breakOffId intValue] == -4) {
        instrument.breakOffId = [NSNumber numberWithInt:2];
    }
    
    if (!instrument.instrumentMethodId || [instrument.instrumentMethodId intValue] == -4) {
        instrument.instrumentMethodId = [NSNumber numberWithInt:1];
    }
    
    if (!instrument.supervisorReviewId || [instrument.supervisorReviewId intValue] == -4) {
        instrument.supervisorReviewId = [NSNumber numberWithInt:2];
    }
    
    if (!instrument.dataProblemId || [instrument.dataProblemId intValue] == -4) {
        instrument.dataProblemId = [NSNumber numberWithInt:2];
    }
}
#pragma mark - Form

- (UIView*) leftInstrumentContentWithFrame:(CGRect)frame contact:(Instrument*)instrument {
    UIView* v = [[UIView alloc] initWithFrame:frame];
    
    FormBuilder* b = [[FormBuilder alloc] initWithView:v object:instrument];
    
    [b sectionHeader:@"Instrument"];
    
    [b labelWithText:@"Instrument Start Date"];
    [b datePickerForProperty:@selector(startDate)];
    
    [b labelWithText:@"Instrument Start Time"];
    [b timePickerForProperty:@selector(startTime)];
    
    [b labelWithText:@"Instrument End Date"];
    [b datePickerForProperty:@selector(endDate)];
    
    [b labelWithText:@"Instrument End Time"];
    [b timePickerForProperty:@selector(endTime)];

    [b labelWithText:@"Instrument Status"];
    [b singleOptionPickerForProperty:@selector(statusId) WithPickerOptions:[MdesCode retrieveAllObjectsForListName:@"INSTRUMENT_STATUS_CL1"]];
    
    [b labelWithText:@"Breakoff"];
    [b singleOptionPickerForProperty:@selector(breakOffId) WithPickerOptions:[MdesCode retrieveAllObjectsForListName:@"CONFIRM_TYPE_CL2"]];
    
    return v;
}

- (UIView*) rightInstrumentContentWithFrame:(CGRect)frame contact:(Instrument*)instrument {
    UIView* v = [[UIView alloc] initWithFrame:frame];
    
    FormBuilder* b = [[FormBuilder alloc] initWithView:v object:instrument];
    
    [b sectionHeader:@""];
     
    [b labelWithText:@"Instrument Mode"];
    [b singleOptionPickerForProperty:@selector(instrumentModeId) WithPickerOptions:[MdesCode retrieveAllObjectsForListName:@"INSTRUMENT_ADMIN_MODE_CL1"]];
    
    [b labelWithText:@"Instrument Mode (Other)"];
    [b textFieldForProperty:@selector(instrumentModeOther)];
    
    [b labelWithText:@"Instrument Method"];
    [b singleOptionPickerForProperty:@selector(instrumentMethodId) WithPickerOptions:[MdesCode retrieveAllObjectsForListName:@"INSTRUMENT_ADMIN_METHOD_CL1"]];
    
    [b labelWithText:@"Comments"];
    [b textAreaForProperty:@selector(comment)];
    
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
    [titleLabel setText:@"Instrument"];
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
        [[NSNotificationCenter defaultCenter] postNotificationName:@"InstrumentVC#done" object:self]; 
    }];
}

- (void) startTransaction {
    NSManagedObjectContext* moc = [self.instrument managedObjectContext];
    NSUndoManager* undoManager = [moc undoManager];
    [undoManager beginUndoGrouping];
}

- (void) endTransction {
    NSManagedObjectContext* moc = [self.instrument managedObjectContext];
    NSUndoManager* undoManager = [moc undoManager];
    [undoManager endUndoGrouping];
    
}

- (void) commitTransaction {
    [self endTransction];
    NSManagedObjectContext* moc = [self.instrument managedObjectContext];
    NSUndoManager* undoManager = [moc undoManager];
    [undoManager removeAllActions];
    
    NSError *error = nil;
    
    if (![moc save:&error]) {
        NSLog(@"Error saving initiated contact");
    }
    NSLog(@"Saved instrument");
}

- (void) rollbackTransaction {
    [self endTransction];
    NSManagedObjectContext* moc = [self.instrument managedObjectContext];
    NSUndoManager* undoManager = [moc undoManager];
    [undoManager undo];
    NSLog(@"Rolledback event");
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
