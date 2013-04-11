//
//  ScreenerChooserViewController.m
//  NCSNavField
//
//  Created by Jacob Van Order on 4/12/13.
//  Copyright (c) 2013 Northwestern University. All rights reserved.
//

#import "ScreenerTypeChooserViewController.h"

#import "EventTemplate.h"

@interface ScreenerTypeChooserViewController ()

@property (strong, nonatomic) IBOutlet UIBarButtonItem *cancelButton;

- (IBAction)cancelButtonWasTapped:(id)sender;

@end

@implementation ScreenerTypeChooserViewController

#pragma mark delegate methods

#pragma mark customization

-(void)setUpScreenerTypeButtons {
    NSArray *screenerTypeEventTemplateArray = [EventTemplate findByAttribute:@"eventTypeCode" withValue:@34];
    NSArray *screenerTypeNamesArray = [screenerTypeEventTemplateArray valueForKeyPath:@"name"];
    
    for (NSString *screenerTypeName in screenerTypeNamesArray) {
        int index = [screenerTypeNamesArray indexOfObject:screenerTypeName];
        UIButton *screenerButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        screenerButton.frame = CGRectMake(40.0f, 40.0f + (68.0f * index), self.view.bounds.size.width - 80.0f, 44.0f);
        [screenerButton addTarget:self action:@selector(screenerTypeButtonWasTapped:) forControlEvents:UIControlEventTouchUpInside];
        [screenerButton setTitle:screenerTypeName forState:UIControlStateNormal];
        [self.view addSubview:screenerButton];
    }
}

#pragma mark prototyping

-(void)screenerTypeButtonWasTapped:(UIButton *)screenerTypeButton {
    [self.delegate screenerTypeChooser:self didChooseScreenerType:screenerTypeButton.titleLabel.text];
}

- (IBAction)cancelButtonWasTapped:(id)sender {
    [self.delegate screenerTypeChooserDidCancel:self];
}

#pragma mark stock code

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonWasTapped:)];
        [self.navigationItem setLeftBarButtonItem:_cancelButton];
        self.title = @"Please choose type";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated {
    [self setUpScreenerTypeButtons];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setCancelButton:nil];
    [super viewDidUnload];
}

@end
