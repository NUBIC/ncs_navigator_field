//
//  SimpleTableRowDelegate.h
//  NCSNavField
//
//  Created by John Dzak on 9/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Row.h"

@protocol SimpleTableRowDelegate <NSObject>

- (void)didSelectRow:(Row*)r;
@end
