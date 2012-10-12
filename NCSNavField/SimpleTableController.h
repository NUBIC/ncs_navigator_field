//
//  SimpleTableController.h
//  NCSNavField
//
//  Created by John Dzak on 9/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISimpleTable.h"

@class Row;

@interface SimpleTableController : UITableViewController {
    id<ISimpleTable> _simpleTable;
}

@property(nonatomic,strong) id<ISimpleTable> simpleTable;

- (void) didSelectRow:(Row*)row;
- (UITableViewCell*)cellForRowClass:(NSString*)rowClass;

@end
