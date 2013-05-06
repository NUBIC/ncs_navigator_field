//
//  NUMultiSurveyTVC.m
//  NCSNavField
//
//  Created by John Dzak on 9/19/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "MultiSurveyTVC.h"
#import <NUSurveyor/NUConstants.h>
#import <JSONKit.h>
#import "NUSurvey+Additions.h"
#import "Participant.h"
#import "ResponseSet.h"
#import "SurveySet.h"
#import "SurveyResponseSetRelationship.h"
#import "ResponseSetMustacheContext.h"
#import <MRCEnumerable/MRCEnumerable.h>
#import "NUSurveyTVC-Private.h"

@interface NUSurveyTVC() <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) UIPickerView *languagePickerView;
@property (nonatomic, strong) UIPopoverController *languagePickerPopoverController;
@property (nonatomic, strong) NSIndexPath *currentSurveyPath;
@property (nonatomic, strong) NSDictionary *translatedTitleDictionary;

- (void) showSection:(NSUInteger) index;
- (void) nextSection;
- (void) prevSection;

-(NSDictionary *)generateTranslatedSectionTitleDictionaryBasedOnLocale:(NSString *)selectedLocale;
@end

@implementation MultiSurveyTVC
@synthesize surveyResponseSetAssociations=_surveyResponseSetAssociations, activeSurveyIndex=_activeSurveyIndex;
@synthesize languagePickerPopoverController, languagePickerView;
@synthesize currentSurveyPath = _currentSurveyPath;
@synthesize translatedTitleDictionary = _translatedTitleDictionary;

#pragma mark language picker

-(void)languageButtonTapped:(UIBarButtonItem *)barButton {
    UIViewController *pickerController = [[UIViewController alloc] init];
    self.languagePickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 216.0f)];
    pickerController.view.bounds = self.languagePickerView.bounds;
    self.languagePickerView.showsSelectionIndicator = YES;
    self.languagePickerView.delegate = self;
    self.languagePickerView.dataSource = self;
    [pickerController.view addSubview:self.languagePickerView];
    self.languagePickerPopoverController = [[UIPopoverController alloc] initWithContentViewController:pickerController];
    self.languagePickerPopoverController.popoverContentSize = self.languagePickerView.bounds.size;
    [self.languagePickerPopoverController presentPopoverFromBarButtonItem:barButton permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    [self.languagePickerView selectRow:0 inComponent:0 animated:YES];
}

- (id)initWithSurveyResponseSetRelationships:(NSArray*)rels {
    SurveyResponseSetRelationship* srsr = [rels count] > 0 ? [rels objectAtIndex:0] : nil;
    
    ResponseSetMustacheContext* mc = [[ResponseSetMustacheContext alloc] initWithResponseSet:srsr.responseSet];
    
    self = [self initWithSurvey:srsr.survey responseSet:srsr.responseSet renderContext:[mc toDictionary]];
    
    if (self) {
        self.surveyResponseSetAssociations = rels;
    }
    return self;
}

- (NSArray*)surveys {
    return [self.surveyResponseSetAssociations collect:^id(SurveyResponseSetRelationship* s) {
        return s.survey;
    }];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView* v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 323, 40)];
    v.backgroundColor = RGB(220, 220, 220);
    
    //Label
    UILabel *t = [[UILabel alloc]initWithFrame:CGRectMake(10, 7, 300, 30)];
    [t setBackgroundColor:[UIColor clearColor]];
    [t setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
    [t setTextColor:[UIColor darkGrayColor]];
    [t setText:[[self.surveys objectAtIndex:section] title]];
    [v addSubview:t];
    
    //Button
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=v.frame;
    button.tag=section;
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    return v;
}

-(IBAction)buttonClicked:(id)sender
{
    self.activeSurveyIndex = [sender tag];
   
    [self.tableView reloadData];    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.surveys count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger rows = 0;
    NUSurvey* s = [self.surveys objectAtIndex:section];
    rows = [[[s.jsonString objectFromJSONString] objectForKey:@"sections"] count];
    
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"NUSurveyVCCell";
        
    // Dequeue or create a cell of the appropriate type.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    // Configure the cell.
    NUSurvey* s = [self.surveys objectAtIndex:indexPath.section];
    NSDictionary* sr = [s.jsonString objectFromJSONString];
    NSDictionary *sectionDictionary = [[sr objectForKey:@"sections"] objectAtIndex:indexPath.row];
    NSString *translatedTitle = [self.translatedTitleDictionary[[s valueForKey:@"uuid"]] objectAtIndex:indexPath.row];
    NSString *defaultTitle = [sectionDictionary objectForKey:@"title"];
	cell.textLabel.text = (translatedTitle) ? translatedTitle : defaultTitle;
    cell.accessibilityLabel = [[[sr objectForKey:@"sections"] objectAtIndex:indexPath.row] objectForKey:@"title"];
	return cell;
}

- (NSInteger) activeSurveyIndex {
    return [self.surveys indexOfObject:self.survey];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[NSNotificationCenter defaultCenter] postNotificationName:MASTER_VC_DID_SELECT_ROW object:nil];
    [self setActiveSurveyWithSurveyIndex:indexPath.section activeSectionWithSectionIndex:indexPath.row];
}

- (void)setActiveSurveyWithSurveyIndex:(NSInteger)sui activeSectionWithSectionIndex:(NSInteger)sei {
    if ([self activeSurveyIndex] != sui) {
        SurveyResponseSetRelationship* srsa = [self.surveyResponseSetAssociations objectAtIndex:sui];
        self.survey = srsa.survey;
        [self setSurveyNSD_Forced:[self.survey.jsonString objectFromJSONString]];
        
        ResponseSet* rs = srsa.responseSet;

        self.sectionTVC.responseSet = rs;
        self.sectionTVC.delegate = self;
        // TODO: Fix render context
        // self.sectionTVC.renderContext = renderContext;
        
        [self.sectionTVC.responseSet setValue:[[self surveyNSD_Forced] objectForKey:@"uuid"] forKey:@"survey"];
        [self.sectionTVC.responseSet generateDependencyGraph:[self surveyNSD_Forced]];
        [NUResponseSet saveContext:self.sectionTVC.responseSet.managedObjectContext withMessage:@"NUSurveyTVC initWithSurvey"];
    }
    
    SurveySet* ss = [[SurveySet alloc] initWithSurveys:self.surveys];
    // REFACTOR: Logic should be moved into sectionTVC?
    NSDictionary* previous = [ss previousSectionfromSurveyIndex:sui sectionIndex:sei];
    self.sectionTVC.prevSectionTitle = previous ? [previous objectForKey:@"title"] : nil;
    NSDictionary* next = [ss nextSectionfromSurveyIndex:sui sectionIndex:sei];
    self.sectionTVC.nextSectionTitle = next ? [next objectForKey:@"title"] : nil;
    [self.sectionTVC setTranslationsArray:[self.surveyNSD objectForKey:@"translations"] forSectionWithUUID:[[ss sectionforSurveyIndex:sui sectionIndex:sei] valueForKey:@"uuid"] withCurrentLocale:[self performSelector:@selector(currentLocale)]];
    [self.sectionTVC setDetailItem:[ss sectionforSurveyIndex:sui sectionIndex:sei]];
    
    [self.sectionTVC.tableView setContentOffset:CGPointMake(0.0, 0.0) animated:NO];
    self.sectionTVC.pageControl.currentPage = sei;
    self.currentSurveyPath = [NSIndexPath indexPathForRow:sei inSection:sui];
}

- (void) nextSection {
    NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
    if ((selectedIndexPath.row + 1) < [[self.surveyNSD objectForKey:@"sections"] count]) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:([self.tableView indexPathForSelectedRow].row + 1) inSection:selectedIndexPath.section];
        [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        [self setActiveSurveyWithSurveyIndex:indexPath.section activeSectionWithSectionIndex:indexPath.row];
        
    }
    else {
        NSIndexPath *nextSectionFirstRowPath = [NSIndexPath indexPathForRow:0 inSection:selectedIndexPath.section + 1];
        if ([self.tableView cellForRowAtIndexPath:nextSectionFirstRowPath]) {
            [self.tableView selectRowAtIndexPath:nextSectionFirstRowPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            [self setActiveSurveyWithSurveyIndex:nextSectionFirstRowPath.section activeSectionWithSectionIndex:nextSectionFirstRowPath.row];
        }
    }
}
- (void) prevSection{
    NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
    if ((selectedIndexPath.row) > 0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:([self.tableView indexPathForSelectedRow].row - 1) inSection:selectedIndexPath.section];
        [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        [self setActiveSurveyWithSurveyIndex:indexPath.section activeSectionWithSectionIndex:indexPath.row];
    }
    else {
        NSUInteger rowNumber = [self.tableView.dataSource tableView:self.tableView numberOfRowsInSection:selectedIndexPath.section - 1] - 1;
        NSIndexPath *previousSectionLastRowPath =  [NSIndexPath indexPathForRow:rowNumber inSection:selectedIndexPath.section - 1];
        if ([self.tableView cellForRowAtIndexPath:previousSectionLastRowPath]) {
            [self.tableView selectRowAtIndexPath:previousSectionLastRowPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            [self setActiveSurveyWithSurveyIndex:previousSectionLastRowPath.section activeSectionWithSectionIndex:previousSectionLastRowPath.row];
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    if ([[self.surveyNSD objectForKey:@"sections"] objectAtIndex:0]) {
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:   NO scrollPosition:UITableViewScrollPositionNone];
        [self setActiveSurveyWithSurveyIndex:0 activeSectionWithSectionIndex:0];
    }
}

#pragma mark - Changes that should be made in Surveyor

- (NSDictionary*) surveyNSD_Forced {
    return [super performSelector:@selector(surveyNSD)];
}

- (NSDictionary*) setSurveyNSD_Forced:(NSDictionary*)surveyNSD {
    return [super performSelector:@selector(setSurveyNSD:) withObject:surveyNSD];
}
//
//- (void) showSection_Forced:(NSUInteger)index {
//    [self performSelector:@selector(showSection) withObject:index];
//}

#pragma mark - translation specific

-(void)surveySelectedLanguage:(NSString *)localeString {
    NSDictionary *selectedLanguageDictionary = [[self.surveyNSD[@"translations"] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"locale == %@", localeString]] lastObject];
    NSString *translatedTitle = (selectedLanguageDictionary[@"title"]) ? selectedLanguageDictionary[@"title"] : self.surveyNSD[@"title"];
    self.sectionTVC.title = translatedTitle;
    self.currentLocale = localeString;
    self.translatedTitleDictionary = [self generateTranslatedSectionTitleDictionaryBasedOnLocale:localeString];
    [self.tableView reloadData];
    [self.tableView selectRowAtIndexPath:self.currentSurveyPath animated:NO scrollPosition:0];
}

-(NSDictionary *)generateTranslatedSectionTitleDictionaryBasedOnLocale:(NSString *)selectedLocale {
    
    if (!selectedLocale) {
        return nil;
    }
    
    NSMutableDictionary *temporaryDictionary = [@{} mutableCopy];
    for (NUSurvey *survey in self.surveys) {
        NSDictionary *surveyDictionary = [survey.jsonString objectFromJSONString];
        NSString *surveyUUID = surveyDictionary[@"uuid"];
        if (!temporaryDictionary[surveyUUID]) {
            temporaryDictionary[surveyUUID] = [@[] mutableCopy];
        }
        for (NSDictionary *sectionDictionary in surveyDictionary[@"sections"]) {
            NSString *sectionUUID = sectionDictionary[@"uuid"];
            NSString *translatedTitle = nil;
            NSDictionary *selectedTranslationDictionary = [[surveyDictionary[@"translations"] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"locale = %@", selectedLocale]] lastObject];
            if (selectedTranslationDictionary) {
                NSDictionary *translatedSection = [[selectedTranslationDictionary[@"sections"] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"uuid = %@", sectionUUID]] lastObject];
                if (translatedSection) {
                    translatedTitle = translatedSection[@"title"];
                }
            }
            [temporaryDictionary[surveyUUID] addObject:(translatedTitle) ? translatedTitle : sectionDictionary[@"title"]];
        }
    }
    return [NSDictionary dictionaryWithDictionary:temporaryDictionary];
}

-(NSDictionary *)translatedTitleDictionary {
    if (!_translatedTitleDictionary) {
        _translatedTitleDictionary = [self generateTranslatedSectionTitleDictionaryBasedOnLocale:self.currentLocale];
    }
    return _translatedTitleDictionary;
}

@end
