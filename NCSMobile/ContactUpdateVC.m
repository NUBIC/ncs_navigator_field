//
//  ContactUpdateVC.m
//  NCSMobile
//
//  Created by John Dzak on 12/4/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ContactUpdateVC.h"
#import "PickerOption.h"
#import "FormBuilder.h"
#import "NUScrollView.h"
#import "Contact.h"

@implementation ContactUpdateVC

@synthesize contact=_contact;

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
    
    UIView* toolbar = [self toolbarWithFrame:CGRectMake(0, -2, self.view.frame.size.width, 50)];
    
    /* Left and Right Pane */
    CGPoint o = self.view.frame.origin;
    CGSize s = self.view.frame.size;
    CGRect rect = CGRectMake(o.x, o.y + 50, s.width, s.height - 50 );
    
    CGRect lRect, rRect;
    CGRectDivide(rect, &rRect, &lRect, rect.size.width / 2, CGRectMaxXEdge);
    
    UIView* left = [self leftContentWithFrame:lRect];
    UIView* right = [self rightContentWithFrame:rRect];
    
    [self.view addSubview:toolbar];
    [self.view addSubview:left];
    [self.view addSubview:right];    
    
    [self startTransaction];
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

- (void) viewDidLoad {
    [super viewDidLoad];
    
    // WARNING: Do not use if you're using self.frame
    // use viewDidAppear instead 
}

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

#pragma mark - Form

- (UIView*) leftContentWithFrame:(CGRect)frame {
    UIView* v = [[UIView alloc] initWithFrame:frame];
    
    FormBuilder* b = [[[FormBuilder alloc] initwithView:v object:self.contact] autorelease];
    
    [b labelWithText:@"Contact Type"];
    [b singleOptionPickerForProperty:@selector(typeId) WithPickerOptions:[PickerOption contactTypes]];

    [b labelWithText:@"Start Date"];
    [b datePickerForProperty:@selector(startDate)];
    
    [b labelWithText:@"End Date"];
    [b datePickerForProperty:@selector(endDate)];
        
    if (false) {
        [b labelWithText:@"Language"];
        [b singleOptionPickerForProperty:@selector(languageId) WithPickerOptions:[PickerOption language]];
        
        [b labelWithText:@"Language (Other)"];
        [b textFieldForProperty:@selector(languageOther)];
        
        [b labelWithText:@"Interpreter"];
        [b singleOptionPickerForProperty:@selector(interpreterId) WithPickerOptions:[PickerOption interpreter]];
        
        [b labelWithText:@"Interpreter (Other)"];
        [b textFieldForProperty:@selector(interpreterOther)];
        
        [b labelWithText:@"Location"];
        [b singleOptionPickerForProperty:@selector(locationId) WithPickerOptions:[PickerOption location]];
        
        [b labelWithText:@"Location (Other)"];
        [b textFieldForProperty:@selector(locationOther)];
        
        [b labelWithText:@"Was contact private"];
        [b singleOptionPickerForProperty:@selector(privateId) WithPickerOptions:[PickerOption private]];
        
        [b labelWithText:@"Private Detail"];
        [b textFieldForProperty:@selector(privateDetail)];
        
        [b labelWithText:@"Distance traveled"];
        [b textFieldForProperty:@selector(distanceId)];
        
        [b labelWithText:@"Disposition"];
        [b singleOptionPickerForProperty:@selector(dispositionId) WithPickerOptions:[PickerOption disposition]];        
    }
    
    return v;
}

- (UIView*) rightContentWithFrame:(CGRect)frame {
    UIView* v = [[UIView alloc] initWithFrame:frame];
    
    FormBuilder* b = [[[FormBuilder alloc] initwithView:v object:self.contact] autorelease];
    
    [b labelWithText:@"Who was contacted"];
    [b singleOptionPickerForProperty:@selector(whoContactedId) WithPickerOptions:[PickerOption whoContacted]];
    
    [b labelWithText:@"Who was contacted (Other)"];
    [b textFieldForProperty:@selector(whoContactedOther)];
    
    [b labelWithText:@"Comments"];
    [b textAreaForProperty:@selector(comments)];

    return v;
}

- (UIView*) toolbarWithFrame:(CGRect)frame {
    UIToolbar* t = [[UIToolbar alloc] initWithFrame:frame];
    
    UIBarButtonItem* cancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    
    UIBarButtonItem* flexItem1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:NULL action:NULL];
    
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0 , 11.0f, 200.0f, 21.0f)];
    [titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setTextColor:[UIColor colorWithRed:113.0/255.0 green:120.0/255.0 blue:128.0/255.0 alpha:1.0]];
    [titleLabel setText:@"Initialize Contact"];
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
    [self dismissModalViewControllerAnimated:YES];
}

- (void) done {
    [self commitTransaction];
    [self dismissModalViewControllerAnimated:YES];
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
    [self endTransction];
    NSManagedObjectContext* moc = [self.contact managedObjectContext];
    NSUndoManager* undoManager = [moc undoManager];
    [undoManager removeAllActions];
    
    NSError *error = nil;
    
    if (![moc save:&error]) {
        NSLog(@"Error saving instrument initialized contact");
    }
    NSLog(@"Initialized contact: %@", self.contact);
}

- (void) rollbackTransaction {
    [self endTransction];
    NSManagedObjectContext* moc = [self.contact managedObjectContext];
    NSUndoManager* undoManager = [moc undoManager];
    [undoManager undo];
    NSLog(@"Rolledback contact: %@", self.contact);

}

@end