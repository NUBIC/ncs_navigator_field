//
//  SimpleTableController.m
//  NCSNavField
//
//  Created by John Dzak on 9/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SimpleTableController.h"
#import "SimpleTableRowDelegate.h"
#import "Section.h"
#import "Row.h"

@implementation SimpleTableController 

@synthesize simpleTable=_simpleTable;

// TODO: Can this be replaced with Three20? (https://github.com/facebook/three20)
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.simpleTable.sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    Section *s = [self.simpleTable.sections objectAtIndex:section];
    return [s.rows count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Section *s = [self.simpleTable.sections objectAtIndex:indexPath.section];
    Row *r = [s.rows objectAtIndex:indexPath.row];
    NSLog(@"%@",s.name);
    
    NSString *cellIdentifier;
    if (r.rowClass) {
        cellIdentifier = r.rowClass;
    } else {
        cellIdentifier = @"default";
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [self cellForRowClass:cellIdentifier];
    }
    
    cell.textLabel.text = r.text;
    cell.detailTextLabel.text = r.detailText;
    
    if([s.name isEqualToString:@"Scheduled Instruments"])
    {
        Instrument *instrument = r.entity;
        if(instrument.startDate) {
            cell.textLabel.textColor = [UIColor blackColor];
            cell.userInteractionEnabled=YES;
        }
        else {
            cell.textLabel.textColor = [UIColor grayColor];
            cell.userInteractionEnabled=NO;
        }
        //We need to check the previous row and see if it has a start date. If it does,
        //and the current row does not we need to enable this one. This is the "current" row.
        if(indexPath.row==0) {
            //This is the first row and therefore should be enabled no matter what.
            cell.textLabel.textColor = [UIColor blackColor];
            cell.userInteractionEnabled=YES;
        }
        else {
            Row *prevRow = [s.rows objectAtIndex:(indexPath.row-1)];
            Instrument *prevInstrument = prevRow.entity;
            if((prevInstrument.startDate)
               &&(!instrument.startDate)) {
                cell.textLabel.textColor = [UIColor blackColor];
                cell.userInteractionEnabled=YES;
            }
        }
    }
    return cell;
}

- (UITableViewCell*)cellForRowClass:(NSString*)rowClass {
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:rowClass];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    Section *s = [self.simpleTable.sections objectAtIndex:section];
    return s.name;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Section *s = [self.simpleTable.sections objectAtIndex:indexPath.section];
    Row *r = [s.rows objectAtIndex:indexPath.row];
    if ([self conformsToProtocol:@protocol(SimpleTableRowDelegate)]) {
        [self didSelectRow:r];
    }
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)setSimpleTable:(id<ISimpleTable>)simpleTable {
    self.simpleTable = simpleTable;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {    
    return YES;  
}

- (void) didSelectRow:(Row*)row {}

@end
