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
#import "Event.h"
#import "Participant.h"
#import <MRCEnumerable/MRCEnumerable.h>

@interface ContactInitiateVC ()

- (void) startTransaction;
- (void) endTransction;
- (void) commitTransaction;
- (void) rollbackTransaction;

@end

@implementation ContactInitiateVC

@synthesize contact=_contact;
@synthesize left,right;

- (id)initWithContact:(Contact *)contact {
    if (self = [super init]) {
        if (!contact) {
            contact = [Contact contact];
            contact.appCreated = @(YES);
        }
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
    NSLog(@"Contact Initiative VC");
    
    UIBarButtonItem* cancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
        
    UIBarButtonItem* done = [[UIBarButtonItem alloc] initWithTitle:@"Start" style:UIBarButtonItemStyleDone target:self action:@selector(done)];
    
    [self.navigationItem setLeftBarButtonItem:cancel];
    [self.navigationItem setRightBarButtonItem:done];
    
    self.title = self.contact.initiated ? @"Continue Contact" : @"Start Contact";
    
    /* Left and Right Pane */
    CGPoint o = self.view.frame.origin;
    CGSize s = self.view.frame.size;
    CGRect rect = CGRectMake(o.x, o.y, s.width, s.height);

    CGRect lRect, rRect;
    CGRectDivide(rect, &rRect, &lRect, rect.size.width / 2, CGRectMaxXEdge);

    [self startTransaction];

    [self setDefaults:self.contact];

    left = [self leftContentWithFrame:lRect];
    right = [self rightContentWithFrame:rRect];

    [self.view addSubview:left];
    [self.view addSubview:right];

    self.view.backgroundColor = [UIColor whiteColor];
}

-(void)viewDidDisappear:(BOOL)animated {
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
    if (!contact.date) {
        contact.date = [NSDate date];
    }

    if (!contact.startTime) {
        contact.startTime = [NSDate date];
    }

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
        [b singleOptionPickerForProperty:@selector(typeId) WithPickerOptions:[MdesCode retrieveAllObjectsForListName:@"CONTACT_TYPE_CL1"]];
        return v;
}

- (UIView*) rightContentWithFrame:(CGRect)frame {
        UIView* v = [[UIView alloc] initWithFrame:frame];
        
        FormBuilder* b = [[FormBuilder alloc] initWithView:v object:self.contact];
        
        [b labelWithText:@"Person Contacted"];
        [b singleOptionPickerForProperty:@selector(whoContactedId) WithPickerOptions:[MdesCode retrieveAllObjectsForListName:@"CONTACTED_PERSON_CL1"]];
        
        [b labelWithText:@"Person Contacted (Other)"];
        [b textFieldForProperty:@selector(whoContactedOther)];
        
        [b labelWithText:@"Comments"];
        [b textAreaForProperty:@selector(comments)];
        return v;
}

- (void) cancel {
    [self rollbackTransaction];
    if (self.shouldDeleteContactOnCancel == YES) {
        NSArray* participants = [[self.contact.events collect:^id(Event* e){
            return [e participant];
        }] allObjects];
        
        [self.contact deleteEntity];
        for (Participant* part in participants) {
            [part deleteEntity];
        }
        [[Contact currentContext] save:nil];
    }
    [self.delegate contactInitiateVCDidCancel:self];
}

- (void) done {
    [self commitTransaction];
    [self.delegate contactInitiateVC:self didContinueWithContact:self.contact]; 
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
    NSLog(@"Initialiated contact: %@", self.contact.contactId);
}

- (void) rollbackTransaction {
    [self endTransction];
    NSManagedObjectContext* moc = [self.contact managedObjectContext];
    NSUndoManager* undoManager = [moc undoManager];
    [undoManager undo];
    NSLog(@"Rolledback contact: %@", self.contact.contactId);
}

@end
