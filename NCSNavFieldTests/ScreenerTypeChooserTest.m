//
//  ScreenerTypeChooserTest.m
//  NCSNavField
//
//  Created by Jacob Van Order on 4/15/13.
//  Copyright (c) 2013 Northwestern University. All rights reserved.
//

#import "ScreenerTypeChooserTest.h"

#import "ContactInitiateVC.h"
#import "RootViewController.h"
#import "ScreenerTypeChooserViewController.h"

#import "NCSFieldConstants.h"

#import "Contact.h"
#import "Person.h"
#import "EventTemplate.h"
#import "Event.h"

//Private methods

@interface ScreenerTypeChooserViewController ()

@property (strong, nonatomic) IBOutlet UIBarButtonItem *cancelButton;

-(void)screenerTypeButtonWasTapped:(UIButton *)screenerTypeButton;
- (IBAction)cancelButtonWasTapped:(id)sender;

-(id) objectForKeyedSubscript:(NSString *)keyString;

@end

//Test

@interface ScreenerTypeChooserTest ()

@property (nonatomic, strong) RootViewController *rootViewController;
@property (nonatomic, strong) ScreenerTypeChooserViewController *screenerTypeChooserViewController;

@end

@implementation ScreenerTypeChooserTest

-(void)setUp {
   
    self.rootViewController = [[RootViewController alloc] init];
    
}

-(void)tearDown {
    self.rootViewController = nil;
    self.screenerTypeChooserViewController = nil;
}

- (void)testThatEnvironmentWorks
{
//    STAssertNotNil(self.store, @"no persistent store");
}


-(void)testBirthCohortChoice {
    
    Event *chosenEvent = [self getMatchingEventWithName:EVENT_TEMPLATE_BIRTH_COHORT andEventTypeCode:@34];
    STAssertNotNil(chosenEvent, @"A birth cohort event was not created");
}

-(void)testPBSScreenerChoice {

    Event *chosenEvent = [self getMatchingEventWithName:EVENT_TEMPLATE_PBS_ELIGIBILITY andEventTypeCode:@34];
    STAssertNotNil(chosenEvent, @"A preg screener was not created");
    
}

-(Event *) getMatchingEventWithName:(NSString *)eventName andEventTypeCode:(NSNumber *)eventTypeCode {
    [[RKObjectManager sharedManager].objectStore deletePersistentStore];
    
    EventTemplate *cohortTemplate = [EventTemplate object];
    cohortTemplate.name = EVENT_TEMPLATE_BIRTH_COHORT;
    cohortTemplate.eventTypeCode = @34;
    
    EventTemplate *pregScreen = [EventTemplate object];
    pregScreen.name = EVENT_TEMPLATE_PBS_ELIGIBILITY;
    pregScreen.eventTypeCode = @34;
    
    STAssertEqualObjects(cohortTemplate, [EventTemplate birthCohortTemplate], @"birth cohort not present");
    STAssertEqualObjects(pregScreen, [EventTemplate pregnancyScreeningTemplate], @"preg screener not present");
    
    self.screenerTypeChooserViewController = [[ScreenerTypeChooserViewController alloc] initWithNibName:nil bundle:nil];
    self.screenerTypeChooserViewController.delegate = self.rootViewController;
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:self.screenerTypeChooserViewController];
    [self.rootViewController addChildViewController:navController];
    [self.screenerTypeChooserViewController viewWillAppear:NO];
    
    UIButton *chosenButton = self.screenerTypeChooserViewController[eventName];
    [self.screenerTypeChooserViewController screenerTypeButtonWasTapped:chosenButton];
    
    ContactInitiateVC *contactVC = navController.viewControllers[1];
    Event *matchingEvent = nil;
    for (Event *contactEvent in contactVC.contact.events) {
        if ([contactEvent.name isEqualToString:eventName] && [contactEvent.eventTypeCode isEqualToNumber:eventTypeCode]) {
            matchingEvent = contactEvent;
        }
    }
    return matchingEvent;
}



@end
