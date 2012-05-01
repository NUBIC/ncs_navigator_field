//
//  RootViewController.m
//  NCSNavField
//
//  Created by John Dzak on 8/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"

#import "NCSNavFieldAppDelegate.h"
#import "ContactDisplayController.h"
#import "ContactNavigationTable.h"
#import "Event.h"
#import "Participant.h"
#import "Contact.h"
#import "Section.h"
#import "Row.h"
#import "NUSurveyTVC.h"
#import "NUSurveyTVC.h"
#import "NUResponseSet.h"
#import "Instrument.h"
#import "InstrumentTemplate.h"
#import "SBJson/SBJsonWriter.h"
#import "NUResponseSet.h"
#import "NUCas.h"
#import "ApplicationSettings.h"
#import "SyncActivityIndicator.h"
#import "NUSurvey.h"
#import "UUID.h"
#import "NUResponseSet.h"
#import "Fieldwork.h"
#import "SBJSON.h"
#import "FieldworkSynchronizeOperation.h"
#import "ApplicationPersistentStore.h"

@interface RootViewController () 
    @property(nonatomic,retain) NSArray* contacts;
    @property(nonatomic,retain) ContactNavigationTable* table;
@end

@implementation RootViewController
		
@synthesize detailViewController=_detailViewController;
@synthesize contacts=_contacts;
@synthesize table=_table;
@synthesize reachability=_reachability;
@synthesize syncIndicator=_syncIndicator;
@synthesize administeredInstrument=_administeredInstrument;
@synthesize serviceTicket=_serviceTicket;

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(instrumentSelected:) name:@"InstrumentSelected" object:NULL];
        
        self.reachability = [[RKReachabilityObserver alloc] initWithHost:@"www.google.com"];
        
        // Register for notifications
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(reachabilityChanged:)
                                                     name:RKReachabilityDidChangeNotification
                                                   object:self.reachability];
    }
    return self;
}


- (void)reachabilityChanged:(NSNotification *)notification {
    RKReachabilityObserver* observer = (RKReachabilityObserver *) [notification object];
    
    RKLogCritical(@"Received reachability update: %@", observer);
  
    if ([observer isNetworkReachable]) {
        if ([observer isConnectionRequired]) {
            return;
        }
        
        self.navigationItem.rightBarButtonItem.enabled = TRUE;
    } else {
        self.navigationItem.rightBarButtonItem.enabled = FALSE;
    }
}

- (void) instrumentSelected:(NSNotification*)notification {
    Instrument* selected = [[notification userInfo] objectForKey:@"instrument"];
    [self loadSurveyor:selected];
}

#pragma surveyor
- (void) loadSurveyor:(Instrument*)instrument {
    if (instrument != NULL) {
        NSString* surveyRep = instrument.instrumentTemplate.representation;
        
        
        //TODO: Pass response set id to load existing if exists
        NUResponseSet* rs = NULL;
        if (instrument.externalResponseSetId != NULL) {
            // TODO: This is a workaround for RestKit failing when entities are named differently than their table name
            //       https://github.com/RestKit/RestKit/issues/506
            //
            //       rs = [NUResponseSet objectWithPredicate: 
            //                  [NSPredicate predicateWithFormat:@"uuid = %@", instrument.externalResponseSetId]];
            //
                        
            NSManagedObjectContext* moc = [NUResponseSet managedObjectContext];
            NSEntityDescription *desc = [NSEntityDescription entityForName:@"ResponseSet" inManagedObjectContext:moc];
            NSFetchRequest *req = [[[NSFetchRequest alloc] init] autorelease];
            
            [req setEntity:desc];
            
            NSPredicate *p = [NSPredicate predicateWithFormat:
                              @"uuid = %@", instrument.externalResponseSetId];
            
            [req setPredicate:p];
            
            NSError *error = nil;
            
            NSArray *array = [moc executeFetchRequest:req error:&error];
            
            if (array == nil)
            {
                NSLog(@"Error during fetch");                
            } else {
                NSLog(@"fetched response set: %@", array);
                rs = [[array objectEnumerator] nextObject];
            }
        }
        
        NUSurvey* survey = [NUSurvey new];
        survey.jsonString = surveyRep;

        if (!rs) {
            NSDictionary* surveyDict = [[SBJSON new] objectWithString:surveyRep];
            rs = [NUResponseSet newResponseSetForSurvey:surveyDict withModel:[RKObjectManager sharedManager].objectStore.managedObjectModel inContext:[NUResponseSet managedObjectContext]];
            
            NSLog(@"Response set uuid: %@", rs.uuid);

            NSManagedObjectContext* moc = [NUResponseSet managedObjectContext];
            instrument.externalResponseSetId = rs.uuid;
            NSError *error = nil;
            
            if (![moc save:&error]) {
                NSLog(@"Error saving instrument uuid");
            }
            NSLog(@"Administered instrument with external response uuid: %@", [instrument externalResponseSetId]);

        }
        
        NUSurveyTVC *masterViewController = [[NUSurveyTVC alloc] initWithSurvey:survey responseSet:rs];
        masterViewController.delegate = self;
        NUSectionTVC *detailViewController = masterViewController.sectionTVC;
        [self.navigationController pushViewController:masterViewController animated:NO];
        self.splitViewController.viewControllers = [NSArray arrayWithObjects:self.navigationController, detailViewController, nil];
        self.administeredInstrument = instrument;
        

    }
}

#pragma mark - surveyor_ios controller delgate
- (void)surveyDone {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark navigation controller delegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    Class src = [[self.splitViewController.viewControllers objectAtIndex:1] class];
    Class dst = [viewController class];
    if ( src == [NUSectionTVC class] &&  dst == [RootViewController class]) {
        NUSectionTVC* sectionVC = (NUSectionTVC*) [self.splitViewController.viewControllers objectAtIndex:1];
        self.splitViewController.viewControllers = [NSArray arrayWithObjects:self.navigationController, _detailViewController, nil];
        NUResponseSet* rs = sectionVC.responseSet;
        if (rs != NULL) {
            [self unloadSurveyor:_administeredInstrument responseSet:rs];
            _administeredInstrument = NULL;
        }
        

    }    
}

- (void) unloadSurveyor:(Instrument*)instrument responseSet:(NUResponseSet*)rs {
    Contact* contact = instrument.event.contact;
    NSDictionary* dict = [[[NSDictionary alloc] initWithObjectsAndKeys:contact, @"contact", instrument, @"instrument", nil] autorelease];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"StoppedAdministeringInstrument" object:self userInfo:dict];
    
//    [surveyorMoc 
    
}
             
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
//    NSLog(@"DELEGATE: switched views: message from the nav controller delegate");
}

#pragma Simple Table
- (void) didSelectRow:(Row*)row {
    self.detailViewController.detailItem = row.entity;
}

#pragma Actions
- (void)syncButtonWasPressed {
    NSLog(@"Sync Pressed!!!");
    if ([ApplicationSettings instance].coreURL) {
        [self confirmSync];
    } else {
        UIAlertView *message = 
            [[UIAlertView alloc] initWithTitle:@"Configuration Error" message:@"The NCS Navigator Core URL has not been configured. Please do this in the Settings app." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [message show];
    }
}

- (void) confirmSync {
    NSInteger closed = 0;
    
    for (Contact* c in self.contacts) {
        if ([c closed]) {
            closed++;
        }
    }
    
    NSString* msg = [NSString stringWithFormat:
                     @"\nThis sync will:\n\n1. Save %d contacts on the server\n2. Retrieve new server contacts\n3. Remove %d completed contacts\n\nWould you like to continue?", [self.contacts count], closed];
    
    UIAlertView *alert = [[[UIAlertView alloc] 
                          initWithTitle: @"Synchronize Contacts"
                          message: msg
                          delegate: self
                          cancelButtonTitle: @"Cancel"
                          otherButtonTitles: @"Sync", nil] autorelease];

    
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (buttonIndex) {
        case 0: 
        {       
            NSLog(@"Delete was cancelled by the user");
        }
        break;
            
        case 1: 
        {
            [self startCasLogin];
        }
        break;
    }
}
- (void) startCasLogin {
    CasLoginVC *login = [[CasLoginVC alloc] init];
    login.delegate = self;
    [self presentViewController:login animated:YES completion:NULL];

}

- (void) deleteButtonWasPressed {
    NSLog(@"Delete button pressed");

    [self purgeDataStore];
    
    self.contacts = [NSArray array];
    
    self.simpleTable = [[ContactNavigationTable alloc] initWithContacts:_contacts];
    
	[self.tableView reloadData];
}

- (void)purgeDataStore {
    ApplicationPersistentStore* s = [ApplicationPersistentStore instance];
    [s remove];
}

#pragma mark - Cas Login Delegate
- (void)successfullyObtainedServiceTicket:(CasServiceTicket*)serviceTicket {
    NSLog(@"My Successful login: %@", serviceTicket);
    [self dismissViewControllerAnimated:YES completion:^{
        [self.syncIndicator show:YES];
        [self syncContacts:serviceTicket];
        [self.syncIndicator hide:YES];
    }];
}

- (void)syncContacts:(CasServiceTicket*)serviceTicket {
    // Bumping the runloop so the UI can update and show the spinner
    // http://stackoverflow.com/questions/5685331/run-mbprogresshud-in-another-thread
    [[NSRunLoop currentRunLoop] runUntilDate: [NSDate distantPast]];
    
    FieldworkSynchronizeOperation* sync = [[FieldworkSynchronizeOperation alloc] initWithServiceTicket:serviceTicket];
    
    [sync perform];
    
    [self loadObjectsFromDataStore];
    
    self.simpleTable = [[ContactNavigationTable alloc] initWithContacts:_contacts];
    
	[self.tableView reloadData];

//    
//    self.serviceTicket = serviceTicket;
//    [self pushContacts:serviceTicket];
//    [self deleteButtonWasPressed];
//    [self retrieveContacts:serviceTicket];
}

#pragma RestKit

- (void)loadObjectsFromDataStore {
	NSFetchRequest* request = [Contact fetchRequest];
	NSSortDescriptor* descriptor = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES];
	[request setSortDescriptors:[NSArray arrayWithObject:descriptor]];
	self.contacts = [[Contact objectsWithFetchRequest:request] retain];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
}

#pragma lifecycle
- (void) loadView {
    [super loadView];
    self.clearsSelectionOnViewWillAppear = NO;
    self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
    self.title = @"Contacts";
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Sync" style:UIBarButtonItemStylePlain target:self action:@selector(syncButtonWasPressed)] autorelease];
    if ([ApplicationSettings instance].isPurgeFieldworkButton) {
        self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deleteButtonWasPressed)] autorelease];
    } else {
        self.navigationItem.leftBarButtonItem = NULL;
    }
    
    // Init Sync Indicators
    self.syncIndicator = [[SyncActivityIndicator alloc] initWithView:self.splitViewController.view];
    self.syncIndicator.delegate = self;

    [self.splitViewController.view addSubview:self.syncIndicator];

    // Load Data from datastore
    [self loadObjectsFromDataStore];
    self.simpleTable = [[ContactNavigationTable alloc] initWithContacts:_contacts];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];

    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}

- (void)dealloc
{
    [_detailViewController release];
    [_contacts release];
    [super dealloc];
}

@end
