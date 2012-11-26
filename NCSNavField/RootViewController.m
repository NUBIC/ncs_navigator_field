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
#import "ResponseSet.h"
#import "Instrument.h"
#import "InstrumentPlan.h"
#import "InstrumentTemplate.h"
#import "SBJson/SBJsonWriter.h"
#import "NUCas.h"
#import "ApplicationSettings.h"
#import "SyncActivityIndicator.h"
#import "NUSurvey.h"
#import "UUID.h"
#import "Fieldwork.h"
#import "SBJSON.h"
#import "FieldworkSynchronizeOperation.h"
#import "ApplicationPersistentStore.h"
#import <MRCEnumerable.h>
#import "MultiSurveyTVC.h"
#import "NUSurvey+Additions.h"
#import "ContactInitiateVC.h"
#import "EventTemplate.h"
#import "Person.h"
#import "ProviderListViewController.h"
#import "ProviderSynchronizeOperation.h"
#import "Provider.h"
#import "ResponseGenerator.h"
#import "SurveyContextGenerator.h"
#import <NUSurveyor/NUResponse.h>

@interface RootViewController () 
    @property(nonatomic,strong) NSArray* contacts;
    @property(nonatomic,strong) ContactNavigationTable* table;
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
    self.accessibilityLabel = @"RootViewControler";
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(instrumentSelected:) name:@"InstrumentSelected" object:NULL];
        
        self.reachability = [[RKReachabilityObserver alloc] initWithHost:@"www.google.com"];
        
        // Register for notifications
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(reachabilityChanged:)
                                                     name:RKReachabilityDidChangeNotification
                                                   object:self.reachability];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toggleDeleteButton) name:SettingsDidChangeNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contactInitiated:) name:@"ContactInitiated" object:NULL];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(providerSelected:) name:PROVIDER_SELECTED_NOTIFICATION_KEY object:NULL];

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

- (void)toggleDeleteButton {
    ApplicationSettings* s = [ApplicationSettings instance];
    if (s.isPurgeFieldworkButton) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deleteButtonWasPressed)];
    } else {
        self.navigationItem.leftBarButtonItem = NULL;
    }
}

- (void) instrumentSelected:(NSNotification*)notification {
    Instrument* selected = [[notification userInfo] objectForKey:@"instrument"];
    Instrument* screener = [EventTemplate pregnancyScreeningInstrument];
    BOOL isPbsScreener = [selected.instrumentPlanId isEqual:screener.instrumentPlanId];
    if (isPbsScreener) {
        ProviderListViewController* plvc = [[ProviderListViewController alloc] initWithNibName:@"ProviderListViewController" bundle:nil];
        plvc.modalPresentationStyle = UIModalPresentationFormSheet;
        plvc.additionalNotificationContext = @{ @"instrument": selected };
        [self presentViewController:plvc animated:NO completion:nil];
    } else {
        selected.startDate = [NSDate date];
        selected.startTime = [NSDate date];
        [[RKObjectManager sharedManager].objectStore.managedObjectContextForCurrentThread save:NULL];
        [self loadSurveyor:selected context:nil];
    }
}

- (void) providerSelected:(NSNotification*)notification {
    Provider* provider = [[notification userInfo] objectForKey:@"provider"];
    Instrument* instrument = [[notification userInfo] objectForKey:@"instrument"];
    
    instrument.startDate = [NSDate date];
    instrument.startTime = [NSDate date];
    [[RKObjectManager sharedManager].objectStore.managedObjectContextForCurrentThread save:NULL];
    SurveyContextGenerator* g = [[SurveyContextGenerator alloc] initWithProvider:provider];
    [self loadSurveyor:instrument context:[g context]];
}

- (void)contactInitiated:(NSNotification*)notification {
    self.contacts = [Contact allObjects];
    ContactNavigationTable* table = [[ContactNavigationTable alloc] initWithContacts:self.contacts];
    self.simpleTable = table;

	[self.tableView reloadData];
    
    Contact* current = [[notification userInfo] objectForKey:@"contact"];
    NSIndexPath* indexPath = [table findIndexPathForContact:current];
    [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    self.detailViewController.detailItem = current;
}

#pragma surveyor
- (void) loadSurveyor:(Instrument*)instrument context:(NSDictionary*)context {
    if (instrument != NULL) {
        NSArray* surveys = [[instrument.instrumentPlan.instrumentTemplates array] collect:^id(InstrumentTemplate* tmpl){
            NUSurvey* s = [NUSurvey new];
            s.jsonString = tmpl.representation;
            return s;
        }];
        
        NSMutableDictionary* assoc = [NSMutableDictionary new];
        for (NUSurvey* s in surveys) {
            ResponseSet* found = [instrument.responseSets detect:^BOOL(ResponseSet* rs) {
                NSString* rsSurveyId = [rs valueForKey:@"survey"];
                return [rsSurveyId isEqualToString:s.uuid];
            }];
            
            if (!found) {
                NCSLog(@"No response set found for survey: %@", s.uuid);
                NSDictionary* surveyDict = [[SBJSON new] objectWithString:s.jsonString];
                found = [ResponseSet newResponseSetForSurvey:surveyDict withModel:[RKObjectManager sharedManager].objectStore.managedObjectModel inContext:[RKObjectManager sharedManager].objectStore.managedObjectContextForCurrentThread];
                [instrument addResponseSetsObject:found];

                NCSLog(@"Creating new response set: %@", found.uuid);
            }
            
            ResponseGenerator* g = [[ResponseGenerator alloc] initWithSurvey:s context:context];
            for (NUResponse* resp in [g responses]) {
                NSArray* existing = [found responsesForQuestion:[resp valueForKey:@"question"]];
                for (NUResponse* e in existing) {
                    [e deleteEntity];
                }
                [found newResponseForQuestion:[resp valueForKey:@"question"] Answer:[resp valueForKey:@"answer"] responseGroup:nil Value:[resp valueForKey:@"value"]];
            }

            [assoc setObject:found forKey:s.uuid];
        }
        
        NSManagedObjectContext* moc = [RKObjectManager sharedManager].objectStore.managedObjectContextForCurrentThread;
        NSError *error = nil;
        
        if (![moc save:&error]) {
            NCSLog(@"Error saving response sets");
        }
        
        NCSLog(@"Loading surveyor with instrument plan: %@", instrument.instrumentPlan.instrumentPlanId);
        
        MultiSurveyTVC *masterViewController = [[MultiSurveyTVC alloc] initWithSurveys:surveys surveyResponseSetAssociations:assoc];
        
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
            [self unloadSurveyor:_administeredInstrument];
            self.administeredInstrument.endDate = [NSDate date];
            self.administeredInstrument.endTime = [NSDate date];
            [[RKObjectManager sharedManager].objectStore.managedObjectContextForCurrentThread save:NULL];
            _administeredInstrument = NULL;
        }
        

    }    
}

- (void) unloadSurveyor:(Instrument*)instrument {
    Contact* contact = instrument.event.contact;
    NSDictionary* dict = [[NSDictionary alloc] initWithObjectsAndKeys:contact, @"contact", instrument, @"instrument", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"StoppedAdministeringInstrument" object:self userInfo:dict];
    
//    [surveyorMoc 
    
}
             
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
//    NCSLog(@"DELEGATE: switched views: message from the nav controller delegate");
}

#pragma Simple Table
- (void) didSelectRow:(Row*)row {
    self.detailViewController.detailItem = row.entity;
}

#pragma Actions
- (void)syncButtonWasPressed {
    NCSLog(@"Sync Pressed!!!");
    if ([[ApplicationSettings instance] coreSynchronizeConfigured]) {
        [self confirmSync];
    } else {
        UIAlertView *message = 
            [[UIAlertView alloc] initWithTitle:@"Configuration Error" message:@"Please go into settings and configure the NCS Field Application before trying to sync." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
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
    
    UIAlertView *alert = [[UIAlertView alloc] 
                          initWithTitle: @"Synchronize Contacts"
                          message: msg
                          delegate: self
                          cancelButtonTitle: @"Cancel"
                          otherButtonTitles: @"Sync", nil];

    
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (buttonIndex) {
        case 0: 
        {       
            NCSLog(@"No was selected by the user");
        }
        break;
            
        case 1: 
        {
            NCSLog(@"Yes was selected by the user");
            [self startCasLogin];
        }
        break;
    }
}
- (void) startCasLogin {
    CasLoginVC *login = [[CasLoginVC alloc] initWithCasConfiguration:[ApplicationSettings casConfiguration]];
    login.delegate = self;
    [self presentViewController:login animated:YES completion:NULL];

}

- (void) deleteButtonWasPressed {
    NCSLog(@"Delete button pressed");

    [self purgeDataStore];
    
    self.contacts = [NSArray array];
}

- (void)setContacts:(NSArray *)contacts {
    _contacts = contacts;
    
    self.simpleTable = [[ContactNavigationTable alloc] initWithContacts:contacts];
    
	[self.tableView reloadData];
    
    self.tableView.tableHeaderView = [self tableHeaderView];
    
    self.detailViewController.detailItem = NULL;
}

- (void)purgeDataStore {
    ApplicationPersistentStore* s = [ApplicationPersistentStore instance];
    [s remove];
}

#pragma mark - Cas Login Delegate
- (void)successfullyObtainedServiceTicket:(CasServiceTicket*)serviceTicket {
    NCSLog(@"My Successful login: %@", serviceTicket);
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
    
    ProviderSynchronizeOperation* pSync = [[ProviderSynchronizeOperation alloc] initWithServiceTicket:serviceTicket];
    
    [pSync perform];

    NcsCodeSynchronizeOperation *nSync = [[NcsCodeSynchronizeOperation alloc] initWithServiceTicket:serviceTicket];
    
    [nSync perform];
    
    self.contacts = [self contactsFromDataStore];
}

#pragma RestKit

- (NSArray*)contactsFromDataStore {
    return [Contact findAllSortedBy:@"date" ascending:YES];
}

#pragma lifecycle
- (void) loadView {
    [super loadView];
//    self.tableclearsSelectionOnViewWillAppear = NO;
    self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
    self.title = @"Contacts";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Sync" style:UIBarButtonItemStylePlain target:self action:@selector(syncButtonWasPressed)];
    [self toggleDeleteButton];
    
    // Init Sync Indicators
    self.syncIndicator = [[SyncActivityIndicator alloc] initWithView:self.splitViewController.view];
    self.syncIndicator.delegate = self;

    [self.splitViewController.view addSubview:self.syncIndicator];

    self.contacts = [self contactsFromDataStore];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tableView.tableHeaderView = [self tableHeaderView];
}

- (UIView*)tableHeaderView {
    UIView* header = nil;
    if ([EventTemplate pregnancyScreeningTemplate]) {
        header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
        UIButton* button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.frame = CGRectMake(0, 5, 150, 40);
        [button setTitle:@"Screen Participant" forState:UIControlStateNormal];
        [header addSubview:button];
        button.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin);
        button.center = header.center;
        [button addTarget:self action:@selector(screenParticipant:) forControlEvents:UIControlEventTouchUpInside];
    }
    return header;
}

- (IBAction)screenParticipant:(UIButton *)button {
    Contact* screening = [Contact object];
    Participant* participant = [Participant participant];
    screening.person = [participant selfPerson];
    EventTemplate* pregnancyScreeningEventTmpl = [EventTemplate pregnancyScreeningTemplate];
    if (pregnancyScreeningEventTmpl) {
        Event* pregnancyScreeningEvent = [pregnancyScreeningEventTmpl buildEventForParticipant:participant];
        [screening addEventsObject:pregnancyScreeningEvent];
        ContactInitiateVC* civc = [[ContactInitiateVC alloc] initWithContact:screening];
        civc.modalPresentationStyle = UIModalPresentationFormSheet;
        [self presentViewController:civc animated:YES completion:nil];
    }
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
    return interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeLeft;
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

@end
