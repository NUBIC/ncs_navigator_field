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
#import "NUCas.h"
#import "ApplicationSettings.h"
#import "SyncActivityIndicator.h"
#import "NUSurvey.h"
#import "NUUUID.h"
#import "Fieldwork.h"
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
#import "MdesCode.h"

#import "NUEndpointCollectionViewController.h"
#import "NUEndpointBar.h"
#import "NUEndpoint.h"

#import "NUManualEndpointEditViewController.h"

@interface RootViewController () <NUEndpointCollectionViewDelegate, NUManualEndpointDelegate, CasLoginVCDelegate>
    @property(nonatomic,strong) NSArray* contacts;
    @property(nonatomic,strong) ContactNavigationTable* table;
    @property(nonatomic,strong) BlockAlertView *alertView;
    @property (nonatomic, strong) UIAlertView *syncAlert;
    @property (nonatomic, strong) UIAlertView *locationAlert;

    @property (nonatomic, strong) NUEndpointBar *endpointBar;

@property (nonatomic, strong) NUManualEndpointEditViewController *manualEndpointEditViewController;

@property (nonatomic, strong) SendOnlyDelegateObject *sendOnlyObject;

-(void)startEndpointSelection;
-(void)switchEndpoint;

-(void)startSyncWithServiceTicket:(CasServiceTicket*)serviceTicket withRetrieval:(BOOL)shouldRetrieve;

@end

@implementation RootViewController
		
@synthesize detailViewController=_detailViewController;
@synthesize contacts=_contacts;
@synthesize table=_table;
@synthesize reachability=_reachability;
@synthesize syncIndicator=_syncIndicator;
@synthesize administeredInstrument=_administeredInstrument;
@synthesize serviceTicket=_serviceTicket;
@synthesize alertView=_alertView;

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    self.accessibilityLabel = @"RootViewControler";
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(instrumentSelected:) name:@"InstrumentSelected" object:NULL];
        backgroundQueue = dispatch_queue_create("edu.northwestern.www", NULL);
        self.reachability = [[RKReachabilityObserver alloc] initWithHost:@"www.google.com"];
        // Register for notifications
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(reachabilityChanged:)
                                                     name:RKReachabilityDidChangeNotification
                                                   object:self.reachability];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toggleDeleteButton) name:SettingsDidChangeNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contactInitiateScreenDismissed:) name:ContactInitiateScreenDismissedNotification object:NULL];
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
    if ([selected isProviderBasedSamplingScreener]) {
        ProviderListViewController* plvc = [[ProviderListViewController alloc] initWithNibName:@"ProviderListViewController" bundle:nil];
        plvc.modalPresentationStyle = UIModalPresentationFormSheet;
        plvc.additionalNotificationContext = @{ @"instrument": selected };
        [self presentViewController:plvc animated:NO completion:nil];
    } else {
        selected.startDate = [NSDate date];
        selected.startTime = [NSDate date];
        [[RKObjectManager sharedManager].objectStore.managedObjectContextForCurrentThread save:NULL];
        [self loadSurveyor:selected responseGeneratorContext:nil];
    }
}

- (void) providerSelected:(NSNotification*)notification {
    Provider* provider = [[notification userInfo] objectForKey:@"provider"];
    Instrument* instrument = [[notification userInfo] objectForKey:@"instrument"];
    
    instrument.startDate = [NSDate date];
    instrument.startTime = [NSDate date];
    [[RKObjectManager sharedManager].objectStore.managedObjectContextForCurrentThread save:NULL];
    SurveyContextGenerator* g = [[SurveyContextGenerator alloc] initWithProvider:provider];
    [self loadSurveyor:instrument responseGeneratorContext:[g context]];
}

- (void)contactInitiateScreenDismissed:(NSNotification*)notification {
    self.contacts = [self contactsFromDataStore];
  
    Contact* current = [[notification userInfo] objectForKey:@"contact"];
    if (current) {
        NSIndexPath* indexPath = [self.table findIndexPathForContact:current];
        [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
        self.detailViewController.detailItem = current;
    }
}

#pragma surveyor
- (void) loadSurveyor:(Instrument*)instrument responseGeneratorContext:(NSDictionary*)context {
    if (instrument != NULL) {
        NSArray* rels = [instrument surveyResponseSetRelationshipsWithResponseGeneratorContext:context];
        
        NSLog(@"Loading surveyor with instrument plan: %@", instrument.instrumentPlan.instrumentPlanId);
        
        MultiSurveyTVC *masterViewController = [[MultiSurveyTVC alloc] initWithSurveyResponseSetRelationships:rels];
        
        masterViewController.delegate = self;
        
        NUSectionTVC *detailViewController = masterViewController.sectionTVC;
        
        [self.navigationController pushViewController:masterViewController animated:NO];
        
        self.splitViewController.viewControllers = [NSArray arrayWithObjects:self.navigationController, detailViewController, nil];
        
        self.administeredInstrument = instrument;
    }
}
-(void)failure:(NSError *)err {
    [self showAlertView:@"The server wouldn't authenticate you."];
    
}

#pragma mark - surveyor_ios controller delgate
- (void)surveyDone {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - endpoint collection view delegate

-(void)endpointCollectionViewControllerDidPressCancel:(NUEndpointCollectionViewController *)collectionView {
    [[NUEndpointService service] stopNetworkRequest];
    if (self.modalViewController) {
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }
}

-(void)endpointCollectionViewController:(NUEndpointCollectionViewController *)collectionView didChooseEndpoint:(NUEndpoint *)chosenEndpoint {
    if ([chosenEndpoint.isManualEndpoint isEqualToNumber:@YES] && collectionView != nil) {
        RootViewController __weak *weakSelf = self;
        [self dismissViewControllerAnimated:YES completion:^{
            RootViewController __strong *strongSelf = weakSelf;
            strongSelf.manualEndpointEditViewController = [[NUManualEndpointEditViewController alloc] initWithNibName:nil bundle:nil];
            strongSelf.manualEndpointEditViewController.alteredEndpoint = chosenEndpoint;
            strongSelf.manualEndpointEditViewController.delegate = self;
            strongSelf.modalPresentationStyle = UIModalPresentationPageSheet;
            [strongSelf presentViewController:strongSelf.manualEndpointEditViewController animated:YES completion:nil];
        }];
    }
    else {
        [[ApplicationSettings instance] updateWithEndpoint:chosenEndpoint];
        RootViewController __weak *weakSelf = self;
        void (^ completionBlock)() = ^ {
            RootViewController __strong *strongSelf = weakSelf;
            [strongSelf setUpEndpointBar];
        };
        if (self.modalViewController) {
            [self dismissViewControllerAnimated:YES completion:completionBlock];
        }
        else {
            completionBlock();
        }
    }
}

#pragma mark - manual endpoint edit delegate


-(void) manualEndpointViewController:(NUManualEndpointEditViewController *)manualEditVC didFinishWithEndpoint:(NUEndpoint *)alteredEndpoint {
    [[ApplicationSettings instance] updateWithEndpoint:alteredEndpoint];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) manualEndpointViewControllerDidCancel:(NUManualEndpointEditViewController *)manualEditVC {
    RootViewController __weak *weakSelf = self;
    [self dismissViewControllerAnimated:YES completion:^{
        [weakSelf switchEndpoint];
    }];
}


#pragma mark - endpoint bar 

-(void)setUpEndpointBar {
    if (!self.endpointBar) {
        self.endpointBar = [[NUEndpointBar alloc] initWithFrame:CGRectMake(0.0f, self.view.frame.size.height - 15.0f, self.view.frame.size.width, 59.0f)];
        [self.navigationController.view addSubview:self.endpointBar];
        [self.endpointBar.endpointBarButton addTarget:self action:@selector(endpointBarButtonWasTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    NUEndpoint *endpoint = [NUEndpoint userEndpointOnDisk];
    if ([endpoint.isManualEndpoint isEqualToNumber:@NO]) {
        NSString *labelString = [NSString stringWithFormat:@"Your current location is:\n%@", endpoint.name];
        NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
        paragraphStyle.lineSpacing = -3.0f;
        NSMutableAttributedString *labelText = [[NSMutableAttributedString alloc] initWithString:labelString attributes:@{NSParagraphStyleAttributeName : paragraphStyle, NSFontAttributeName : [UIFont systemFontOfSize:13]}];
        [labelText addAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:13]}  range:[labelString rangeOfString:endpoint.name]];
        self.endpointBar.endpointBarLabel.attributedText = labelText;
        [self.endpointBar.endpointBarButton setTitle:@"Switch location" forState:UIControlStateNormal];
    }
    else if ([endpoint.isManualEndpoint isEqualToNumber:@YES]) {
        self.endpointBar.endpointBarLabel.attributedText = [[NSAttributedString alloc] initWithString:@"You are using\nmanual mode" attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:13]}];
        [self.endpointBar.endpointBarButton setTitle:@"Switch location" forState:UIControlStateNormal];
    }
    else {
        self.endpointBar.endpointBarLabel.text = @"No location chosen";
        [self.endpointBar.endpointBarButton setTitle:@"Pick location" forState:UIControlStateNormal];
    }
}

-(void)endpointBarButtonWasTapped:(UIButton *)endpointBarButton {
    if ([self.contacts count] > 0) {
        NSInteger closed = 0;
        for (Contact* c in self.contacts) {
            closed = ([c closed] == YES)? closed++ : closed;
        }
        self.locationAlert = [[UIAlertView alloc] initWithTitle:@"Switch Location" message:[NSString stringWithFormat:@"You have %i contacts and %i events finished, would you like to sync?", [self.contacts count], closed] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Sync", nil];
        [self.locationAlert show];
    }
    else {
        [self switchEndpoint];
    }
}

#pragma mark -
#pragma mark navigation controller delegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    Class src = [[self.splitViewController.viewControllers objectAtIndex:1] class];
    Class dst = [viewController class];
    if ( src == [NUSectionTVC class] &&  dst == [RootViewController class]) {
        self.splitViewController.viewControllers = [NSArray arrayWithObjects:self.navigationController, _detailViewController, nil];
        [self unloadSurveyor:self.administeredInstrument];
    }
}

- (void) unloadSurveyor:(Instrument*)instrument {
    if (instrument) {
        instrument.endDate = [NSDate date];
        instrument.endTime = [NSDate date];
        for (ResponseSet* r in instrument.responseSets) {
            [r setValue:[NSDate date] forKey:@"completedAt"];
        }
    }

    [[RKObjectManager sharedManager].objectStore.managedObjectContextForCurrentThread save:NULL];
    
    self.administeredInstrument = NULL;
    Contact* contact = instrument.event.contact;
    NSDictionary* dict = [[NSDictionary alloc] initWithObjectsAndKeys:contact, @"contact", instrument, @"instrument", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"StoppedAdministeringInstrument" object:self userInfo:dict];
}
             
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
//    NSLog(@"DELEGATE: switched views: message from the nav controller delegate");
}

#pragma Simple Table
- (void) didSelectRow:(Row*)row {
    self.detailViewController.detailItem = row.entity;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Section *s = [self.simpleTable.sections objectAtIndex:indexPath.section];
        Row *r = [s.rows objectAtIndex:indexPath.row];
        if ([[r entity] isKindOfClass:[Contact class]]) {
            Contact *contactToRemove = [r entity];
            
            if ([self.detailViewController.detailItem isEqual:contactToRemove] == YES) {
                self.detailViewController.detailItem = nil;
            }
            
            if ([contactToRemove deleteFromManagedObjectContext:[NSManagedObjectContext contextForCurrentThread]] == YES) {
                [self removeContactFromTableView:tableView atIndex:indexPath withRemaingContactsInSection:[s.rows count]];
            }
        }
    }
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    Section *s = [self.simpleTable.sections objectAtIndex:indexPath.section];
    Row *r = [s.rows objectAtIndex:indexPath.row];
    if ([[r entity] isKindOfClass:[Contact class]]) {
        Contact *contact = [r entity];
        return [contact.appCreated boolValue];
    }
    else {
        return NO;
    }
}

#pragma Actions
- (void)syncButtonWasPressed {
    
    if ([NUEndpoint userEndpointOnDisk] != nil) {
        NSString *emptyUrl = nil;
        [[ApplicationSettings instance] coreSynchronizeConfigured:&emptyUrl];
        if (emptyUrl != nil) {
            [self showAlertView:[NSString stringWithFormat:@"\"%@\" is empty in your settings. We need that info!",emptyUrl]];
        }
        else {
            [self confirmSync];
        }
    }
    else {
        [self showAlertView:[NSString stringWithFormat:@"Please pick a location."]];
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
    
    self.syncAlert = [[UIAlertView alloc]
                          initWithTitle: @"Synchronize Contacts"
                          message: msg
                          delegate: self
                          cancelButtonTitle: @"Cancel"
                          otherButtonTitles: @"Sync", nil];
    [self.syncAlert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if ([alertView isEqual:self.locationAlert]) {
        switch (buttonIndex) {
            case 0:
            {
                NSLog(@"No was selected by the user");
            }
                break;
                
            case 1:
            {
                NSLog(@"Yes was selected by the user");
                [self startCasLoginWithRetrieval:NO];
            }
                break;
        }
    }
    else {
        switch (buttonIndex) {
            case 0:
            {
                NSLog(@"No was selected by the user");
            }
                break;
                
            case 1:
            {
                NSLog(@"Yes was selected by the user");
                [self startCasLoginWithRetrieval:YES];
            }
                break;
        }
    }
}
- (void)startCasLoginWithRetrieval:(BOOL)shouldRetrieve {
    CasLoginVC *login = [[CasLoginVC alloc] initWithCasConfiguration:[ApplicationSettings casConfiguration]];
    if (shouldRetrieve == YES) {
        login.casLoginDelegate = self;
    }
    else {
        self.sendOnlyObject = [SendOnlyDelegateObject new];
        self.sendOnlyObject.delegate = self;
        login.casLoginDelegate = self.sendOnlyObject;
    }
    
    [self presentViewController:login animated:YES completion:NULL];

}

- (void) deleteButtonWasPressed {
    [self purgeDataStore];

//    [NUEndpoint deleteUserEndpoint];
//    [[ApplicationSettings instance] updateWithEndpoint:nil];
//    [self setUpEndpointBar];
    
    self.contacts = [NSArray array];
}

- (void)setContacts:(NSArray *)contacts {
    _contacts = contacts;
    
    self.simpleTable = [[ContactNavigationTable alloc] initWithContacts:contacts];
    
	[self.tableView reloadData];
    
    self.tableView.tableHeaderView = [self tableHeaderView];
    
    self.detailViewController.detailItem = NULL;
}

-(void)removeContactFromTableView:(UITableView *)tableView atIndex:(NSIndexPath *)indexPath withRemaingContactsInSection:(NSUInteger)remainingContacts {
       
    _contacts = [self contactsFromDataStore];
    
    self.simpleTable = [[ContactNavigationTable alloc] initWithContacts:_contacts];
    
    [tableView beginUpdates];
    if (remainingContacts == 1) {
        [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    else {
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    [tableView endUpdates];
    
    self.tableView.tableHeaderView = [self tableHeaderView];
    
    self.detailViewController.detailItem = NULL;
}

- (void)purgeDataStore {
    ApplicationPersistentStore* s = [ApplicationPersistentStore instance];
    [s remove];
}

-(void)startEndpointSelection {
    NUEndpointCollectionViewController *endpointCollectionViewController = [[NUEndpointCollectionViewController alloc] initWithNibName:nil bundle:nil];
    endpointCollectionViewController.delegate = self;
    endpointCollectionViewController.modalPresentationStyle = UIModalPresentationPageSheet;
    [self presentViewController:endpointCollectionViewController animated:YES completion:^{
        [endpointCollectionViewController getEndpointsFromService:nil];
    }];
}

-(void)switchEndpoint {
    [self startEndpointSelection];
}

#pragma mark - Cas Login Delegate

- (void)casLoginVC:(CasLoginVC *)casLoginVC didSuccessfullyObtainedServiceTicket:(CasServiceTicket *)serviceTicket {
    [self startSyncWithServiceTicket:serviceTicket withRetrieval:YES];
}

-(void)casLoginVCDidCancel:(CasLoginVC *)casLoginVC {
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)setHUDMessage:(NSString*)strMessage {
        self.syncIndicator.labelFont = [UIFont fontWithName:self.syncIndicator.labelFont.fontName size:24.0];
        [self.syncIndicator show:YES];
        self.syncIndicator.mode = MBProgressHUDModeIndeterminate;
        [self.syncIndicator setLabelText:strMessage];
        [self.syncIndicator setDetailsLabelText:@""];
}

-(void)setHUDMessage:(NSString*)strMessage andDetailMessage:(NSString *)detailMessage {
        self.syncIndicator.mode = MBProgressHUDModeIndeterminate;
        [self.syncIndicator setLabelText:strMessage];
        [self.syncIndicator setDetailsLabelText:detailMessage];
}

-(void)setHUDMessage:(NSString*)strMessage withFontSize:(CGFloat)f {
        self.syncIndicator.mode = MBProgressHUDModeIndeterminate;
        [self.syncIndicator setLabelText:strMessage];
        [self.syncIndicator setDetailsLabelText:@""];
        [self.syncIndicator setLabelFont:[UIFont fontWithName:self.syncIndicator.labelFont.fontName size:f]];
}

-(void)setHUDMessage:(NSString*)strMessage andDetailMessage:(NSString*)detailMessage withMajorFontSize:(CGFloat)f {
    //dispatch_async(dispatch_get_main_queue(), ^{
        self.syncIndicator.mode = MBProgressHUDModeIndeterminate;
        [self.syncIndicator setLabelText:strMessage];
        self.syncIndicator.labelText = strMessage;
        [self.syncIndicator setDetailsLabelText:detailMessage];
        [self.syncIndicator setLabelFont:[UIFont fontWithName:self.syncIndicator.labelFont.fontName size:f]];
        [self.syncIndicator setDetailsLabelText:detailMessage];
        [self.syncIndicator setNeedsLayout];
        [self.syncIndicator setNeedsDisplay];
    //});
}
-(void)setHUDMessage:(NSString*)strMessage andDetailMessage:(NSString*)detailMessage withMajorFontSize:(CGFloat)f andMinorFontSize:(CGFloat)g {
        self.syncIndicator.mode = MBProgressHUDModeIndeterminate;
        [self.syncIndicator setLabelText:strMessage];
        [self.syncIndicator setDetailsLabelText:detailMessage];
        [self.syncIndicator setLabelFont:[UIFont fontWithName:self.syncIndicator.labelFont.fontName size:f]];
        [self.syncIndicator setDetailsLabelText:detailMessage];
        [self.syncIndicator setDetailsLabelFont:[UIFont fontWithName:self.syncIndicator.labelFont.fontName size:g]];
}

-(void)hideHUD {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.syncIndicator hide:YES];
    });
}

- (void)syncContacts:(CasServiceTicket*)serviceTicket withRetrieval:(BOOL)shouldRetrieve {
// Bumping the runloop so the UI can update and show the spinner
// http://stackoverflow.com/questions/5685331/run-mbprogresshud-in-another-thread
    @try {
        //[[NSRunLoop currentRunLoop] runUntilDate: [NSDate distantPast]];
        NSManagedObjectContext *moc = [NSManagedObjectContext contextForCurrentThread];
        BOOL bStepWasSuccessful;
        //This has many, many substeps that we need to clarify.
        FieldworkSynchronizeOperation* sync = [[FieldworkSynchronizeOperation alloc] initWithServiceTicket:serviceTicket];
        sync.delegate=self;
        bStepWasSuccessful = [sync performWithRetrieval:shouldRetrieve];
        NSLog(@"Fieldwork sync: %@", bStepWasSuccessful ? @"Success" : @"Fail");
        
        if(!bStepWasSuccessful) //Should we stop right here? If we failed on fieldwork synchronization.
            return;
        
        if (shouldRetrieve == NO) {
            [self deleteButtonWasPressed];
            [self startEndpointSelection];
            return;
        }
        
        //Let's take the MOC and get rid of duplicates.
        [Provider truncateAllInContext:moc];
        ProviderSynchronizeOperation* pSync = [[ProviderSynchronizeOperation alloc] initWithServiceTicket:serviceTicket];
        pSync.delegate = self;
        bStepWasSuccessful = [pSync perform];
        NSLog(@"Provider sync: %@", bStepWasSuccessful ? @"Success" : @"Fail");

        
        if(!bStepWasSuccessful) //Should we stop right here? If the provider pull didn't work, stop.
            return;
        
        [MdesCode truncateAllInContext:moc];
        NcsCodeSynchronizeOperation *nSync = [[NcsCodeSynchronizeOperation alloc] initWithServiceTicket:serviceTicket];
        nSync.delegate = self;
        bStepWasSuccessful = [nSync perform];
        NSLog(@"NCS Code sync: %@", bStepWasSuccessful ? @"Success" : @"Fail");
    }
    //In the future, these two catches will diverge. Right now, let's just put a placeholder. 
    @catch (FieldworkSynchronizationException *ex) {
        NSLog(@"%@\n%@",[ex debugDescription], [ex name]);
    }
    @catch(NSException *ex) {
        NSLog(@"%@\n%@",[ex debugDescription], [ex name]);
    }
    @finally {
        //BE CAREFUL: this could hide a bug above. Make sure to look if an exception is printed out!!!
        [self hideHUD];
    }
    
    self.contacts = [self contactsFromDataStore];
}

-(void)startSyncWithServiceTicket:(CasServiceTicket*)serviceTicket withRetrieval:(BOOL)shouldRetrieve {
    NSLog(@"My Successful login: %@", serviceTicket);
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        [self setHUDMessage:SYNCING_CONTACTS];
    });
    [self dismissViewControllerAnimated:YES completion:^{
        //Running on another thread instead of the main runloop
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            self.syncIndicator.labelFont = [UIFont fontWithName:self.syncIndicator.labelFont.fontName size:24.0];
            [self.syncIndicator show:YES];
            [self syncContacts:serviceTicket withRetrieval:shouldRetrieve];
            [self hideHUD];
        });
    }];
}

#pragma mark
#pragma mark - Send Only Delegate

-(void)sendOnlyDelegate:(SendOnlyDelegateObject *)retrieveDelegateObject didSuccessfullyObtainedServiceTicket:(CasServiceTicket *)serviceTicket {
    [self startSyncWithServiceTicket:serviceTicket withRetrieval:NO];
}

-(void)sendOnlyDelegateDidCancel:(SendOnlyDelegateObject *)retrieveDelegateObject {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark
#pragma mark - UserErrorDelegate

-(void)showAlertView:(NSString*)strError {
    dispatch_async(dispatch_get_main_queue(), ^{
        
    //https://github.com/gpambrozio/BlockAlertsAnd-ActionSheets
    _alertView = [BlockAlertView alertWithTitle:@"Whoops!" message:[NSString stringWithFormat:@"Something has gone wrong with your sync. %@",strError]];
    
    //Needed to prevent retain cycle.
    __block RootViewController *blocksafeSelf = self;
    
    [_alertView setCancelButtonWithTitle:@"Try Again" block:^(){
        [blocksafeSelf syncButtonWasPressed];}
     ];
    [_alertView setDestructiveButtonWithTitle:@"Cancel" block:^(){}];
    [_alertView show];
    
    });
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
 //        UIView *topView = [[[(NCSNavFieldAppDelegate *)[[UIApplication sharedApplication] delegate] window] subviews] objectAtIndex:0];
        UIView *topView = [(NCSNavFieldAppDelegate *)[[UIApplication sharedApplication] delegate] window];
        self.syncIndicator = [[SyncActivityIndicator alloc] initWithView:topView];
        self.syncIndicator.delegate = self;

        [topView addSubview:self.syncIndicator];

        self.contacts = [self contactsFromDataStore];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tableView.tableHeaderView = [self tableHeaderView];
    [self setUpEndpointBar];
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
    // Existing InstrumentTemplates may not have their questions
    // loaded into Core Data since that happens during sync
    NSPredicate* missingQuestions = [NSPredicate predicateWithFormat:@"questions.@count == 0"];
    NSArray* instrumentTemplates = [InstrumentTemplate findAllWithPredicate:missingQuestions];
    for (InstrumentTemplate* it in instrumentTemplates) {
        [it refreshQuestionsFromSurvey];
    }

    Contact* screening = [Contact contact];
    screening.appCreated = @(YES);
    
    Participant* participant = [Participant participant];
    Person* person = [participant selfPerson];
    screening.person = person;
    screening.personId = person.personId;
    
    EventTemplate* pregnancyScreeningEventTmpl = [EventTemplate pregnancyScreeningTemplate];
    if (pregnancyScreeningEventTmpl) {
        [screening addEventsObject:[pregnancyScreeningEventTmpl buildEventForParticipant:participant person:person]];
    }
    
    ContactInitiateVC* civc = [[ContactInitiateVC alloc] initWithContact:screening];
    civc.afterCancel = ^(Contact* screening){
        NSArray* participants = [[screening.events collect:^id(Event* e){
            return [e participant];
        }] allObjects];
        
        [screening deleteEntity];
        for (Participant* part in participants) {
            [part deleteEntity];
        }
        [[Contact currentContext] save:nil];
    };
    
    civc.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:civc animated:YES completion:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:HAS_MIGRATED_TO_AUTO_LOCATION] == YES) {
        NUEndpoint *endpoint = [NUEndpoint userEndpointOnDisk];
        if (!endpoint) {
            [self startEndpointSelection];
        }
    }
    else {
        NUEndpoint *migratedEndpoint = [NUEndpoint migrateUserToAutoLocation];
        if (migratedEndpoint != nil) {
            [self endpointCollectionViewController:nil didChooseEndpoint:migratedEndpoint];
        }
        else {
            [self startEndpointSelection];
        }
    }

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
