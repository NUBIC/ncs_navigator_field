//
//  NUManualEndpointEditViewController.m
//  NCSNavField
//
//  Created by Jacob Van Order on 4/4/13.
//  Copyright (c) 2013 Northwestern University. All rights reserved.
//

#import "NUManualEndpointEditViewController.h"

#import "NUEndpoint.h"
#import "NUEndpointEnvironment.h"

@interface NUManualEndpointEditViewController () <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *casesUrlTextField;
@property (strong, nonatomic) IBOutlet UITextField *baseCasUrlTextField;
@property (strong, nonatomic) IBOutlet UITextField *casReceiveUrlTextField;
@property (strong, nonatomic) IBOutlet UITextField *casRetrieveUrlTextField;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *saveButton;

- (IBAction)cancelButtonWasTapped:(id)sender;
- (IBAction)saveButtonWasTapped:(id)sender;


@end

@implementation NUManualEndpointEditViewController

#pragma mark delegate methods

#pragma mark customization

- (IBAction)cancelButtonWasTapped:(id)sender {
    [self.delegate manualEndpointViewControllerDidCancel:self];
}

- (IBAction)saveButtonWasTapped:(id)sender {
    
    NSArray *environmentsArray = @[PRODUCTION_ENV, STAGING_ENV];
    NSArray *newEnvironmentsArray = @[];
    for (NSString *environmentName in environmentsArray) {
        NUEndpointEnvironment *newEnvironment = [NUEndpointEnvironment new];
        newEnvironment.casServerURL = [NSURL URLWithString:self.baseCasUrlTextField.text];
        newEnvironment.coreURL = [NSURL URLWithString:self.casesUrlTextField.text];
        newEnvironment.pgtReceiveURL = [NSURL URLWithString:self.casReceiveUrlTextField.text];
        newEnvironment.pgtRetrieveURL = [NSURL URLWithString:self.casRetrieveUrlTextField.text];
        newEnvironment.name = environmentName;
        newEnvironmentsArray = [newEnvironmentsArray arrayByAddingObject:newEnvironment];
    }
    
    self.alteredEndpoint.environmentArray = newEnvironmentsArray;
    self.alteredEndpoint.enviroment = [self.alteredEndpoint environmentBasedOnCurrentBuildFromArray:newEnvironmentsArray];
    
    [self.delegate manualEndpointViewController:self didFinishWithEndpoint:self.alteredEndpoint];
}

-(void)setAlteredEndpoint:(NUEndpoint *)alteredEndpoint {
    _alteredEndpoint = alteredEndpoint;
}

#pragma mark prototyping

#pragma mark stock code

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewDidAppear:(BOOL)animated {
    self.baseCasUrlTextField.text = self.alteredEndpoint.enviroment.casServerURL.absoluteString;
    self.casesUrlTextField.text = self.alteredEndpoint.enviroment.coreURL.absoluteString;
    self.casReceiveUrlTextField.text = self.alteredEndpoint.enviroment.pgtReceiveURL.absoluteString;
    self.casRetrieveUrlTextField.text = self.alteredEndpoint.enviroment.pgtRetrieveURL.absoluteString;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setCasesUrlTextField:nil];
    [self setBaseCasUrlTextField:nil];
    [self setCasReceiveUrlTextField:nil];
    [self setCasRetrieveUrlTextField:nil];
    [self setSaveButton:nil];
    [self setCancelButton:nil];
    [super viewDidUnload];
}

@end
