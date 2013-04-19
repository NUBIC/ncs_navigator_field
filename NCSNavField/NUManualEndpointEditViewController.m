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

@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *urlTextFieldArray;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *saveButton;

- (IBAction)cancelButtonWasTapped:(id)sender;
- (IBAction)saveButtonWasTapped:(id)sender;

-(NSArray *)invalidURLTextFieldArray;

@end

@implementation NUManualEndpointEditViewController

#pragma mark delegate methods

#pragma mark customization

- (IBAction)cancelButtonWasTapped:(id)sender {
    [self.delegate manualEndpointViewControllerDidCancel:self];
}

- (IBAction)saveButtonWasTapped:(id)sender {
    
    if ([[self invalidURLTextFieldArray] count] == 0) {
        NUEndpointEnvironment *newEnvironment = [NUEndpointEnvironment new];
        newEnvironment.casServerURL = [NSURL URLWithString:self.baseCasUrlTextField.text];
        newEnvironment.coreURL = [NSURL URLWithString:self.casesUrlTextField.text];
        newEnvironment.pgtReceiveURL = [NSURL URLWithString:self.casReceiveUrlTextField.text];
        newEnvironment.pgtRetrieveURL = [NSURL URLWithString:self.casRetrieveUrlTextField.text];
        newEnvironment.name = @"manual";
        
        self.alteredEndpoint.environmentArray = @[newEnvironment];
        self.alteredEndpoint.enviroment = newEnvironment;
        
        [self.delegate manualEndpointViewController:self didFinishWithEndpoint:self.alteredEndpoint];
    }
    else {
        NSArray *problemTextFieldArray = [self invalidURLTextFieldArray];
        NSArray *problemTextFieldDescriptionArray = [problemTextFieldArray valueForKeyPath:@"accessibilityLabel"];
        
        NSString *descriptionString = [@"You seem to have an invalid url in: " stringByAppendingString:[problemTextFieldDescriptionArray componentsJoinedByString:@", "]];
        UIAlertView *badURLAlert = [[UIAlertView alloc] initWithTitle:@"Invalid URL"
                                                              message: descriptionString
                                                             delegate:nil
                                                    cancelButtonTitle:@"Okay"
                                                    otherButtonTitles:nil];
        [badURLAlert show];
    }
}

-(void)setAlteredEndpoint:(NUEndpoint *)alteredEndpoint {
    _alteredEndpoint = alteredEndpoint;
}

-(NSArray *)invalidURLTextFieldArray {
    NSArray *returnArray = @[];
    for (UITextField *textField in self.urlTextFieldArray) {
        NSURL *textFieldURL = [NSURL URLWithString:textField.text];
        if ((textFieldURL && textFieldURL.scheme && textFieldURL.host) == NO)
            returnArray = [returnArray arrayByAddingObject:textField];
    }
    return returnArray;
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
    [self setUrlTextFieldArray:nil];
    [super viewDidUnload];
}

@end
