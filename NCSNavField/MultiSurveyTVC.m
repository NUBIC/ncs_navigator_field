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
#import <MRCEnumerable/MRCEnumerable.h>

@interface NUSurveyTVC()
- (void) showSection:(NSUInteger) index;
@end

@implementation MultiSurveyTVC
@synthesize surveyResponseSetAssociations=_surveyResponseSetAssociations, activeSurveyIndex=_activeSurveyIndex;

- (id)initWithSurveyResponseSetRelationships:(NSArray*)rels {
    SurveyResponseSetRelationship* srsr = [rels count] > 0 ? [rels objectAtIndex:0] : nil;
    
    self = [self initWithSurvey:srsr.survey responseSet:srsr.responseSet renderContext:@{}];
    
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
	cell.textLabel.text = [[[sr objectForKey:@"sections"] objectAtIndex:indexPath.row] objectForKey:@"title"];
    cell.accessibilityLabel = [[[sr objectForKey:@"sections"] objectAtIndex:indexPath.row] objectForKey:@"title"];
	return cell;
}

- (NSInteger) activeSurveyIndex {
    return [self.surveys indexOfObject:self.survey];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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
    [self.sectionTVC setDetailItem:[ss sectionforSurveyIndex:sui sectionIndex:sei]];
    [self.sectionTVC.tableView setContentOffset:CGPointMake(0.0, 0.0) animated:NO];
    self.sectionTVC.pageControl.currentPage = sei;
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

@end
