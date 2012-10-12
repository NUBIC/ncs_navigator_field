//
//  ContactUpdateVC.m
//  NCSNavField
//
//  Created by John Dzak on 12/4/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ContactInitiateVC.h"
#import "PickerOption.h"
#import "FormBuilder.h"
#import "NUScrollView.h"
#import "Contact.h"

@implementation ContactInitiateVC

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

    [self startTransaction];

    [self setDefaults:self.contact];
    
    UIView* left = [self leftContentWithFrame:lRect];
    UIView* right = [self rightContentWithFrame:rRect];
    

    [self.view addSubview:toolbar];
    [self.view addSubview:left];
    [self.view addSubview:right];
    self.view.backgroundColor = [UIColor whiteColor];
    
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

- (void) setDefaults:(Contact*) contact {
    contact.startTime = [NSDate date];
    
    if (!contact.typeId || [contact.typeId intValue] == -4) {
        contact.typeId = [NSNumber numberWithInt:1];
    }
    
    if (!contact.whoContactedId || [contact.whoContactedId intValue] == -4) {
        contact.whoContactedId = [NSNumber numberWithInt:1];
    }
}

- (UIView*) leftContentWithFrame:(CGRect)frame {
    UIView* v = [[UIView alloc] initWithFrame:frame];
    
    FormBuilder* b = [[FormBuilder alloc] initWithView:v object:self.contact];

    [b labelWithText:@"Contact Date"];
    [b datePickerForProperty:@selector(date)];
    
    [b labelWithText:@"Contact Start Time"];
    [b timePickerForProperty:@selector(startTime)];
    
    [b labelWithText:@"Contact Method"];
    [b singleOptionPickerForProperty:@selector(typeId) WithPickerOptions:[PickerOption contactTypes]];

        
    return v;
}

- (UIView*) rightContentWithFrame:(CGRect)frame {
    UIView* v = [[UIView alloc] initWithFrame:frame];
    
    FormBuilder* b = [[FormBuilder alloc] initWithView:v object:self.contact];
    
    [b labelWithText:@"Person Contacted"];
    [b singleOptionPickerForProperty:@selector(whoContactedId) WithPickerOptions:[PickerOption whoContacted]];
    
    [b labelWithText:@"Person Contacted (Other)"];
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
    [titleLabel setText:(self.contact.initiated ? @"Continue Contact" : @"Start Contact")];
    [titleLabel setTextAlignment:UITextAlignmentCenter];
    UIBarButtonItem *toolBarTitle = [[UIBarButtonItem alloc] initWithCustomView:titleLabel];
    
    
    
    UIBarButtonItem* flexItem2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:NULL action:NULL];
    
    UIBarButtonItem* done = [[UIBarButtonItem alloc] initWithTitle:@"Start" style:UIBarButtonItemStyleDone target:self action:@selector(done)];
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
    [self dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ContactInitiated" object:self];
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
    NCSLog(@"Initialiated contact: %@", self.contact.contactId);
}

- (void) rollbackTransaction {
    [self endTransction];
    NSManagedObjectContext* moc = [self.contact managedObjectContext];
    NSUndoManager* undoManager = [moc undoManager];
    [undoManager undo];
    NCSLog(@"Rolledback contact: %@", self.contact.contactId);
}


@end
