//
//  EventSorter.h
//  NCSNavField
//
//  Created by Sam Hicks on 11/30/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+ParsingExtensions.h"
/*

 Event Sort falls the GoF Singleton design pattern. It reads from a file called Event_Type_Sort_Order
 upon instantiation and then returns all interested parties the sort order through accessor methods.
 @See: Event_Type_Sort_Order in this bundle
 @See: NSString+ParsingExtensions
 
 Use this something like:
    NSDictionary *sortOder = [[EventSorter instance] sortOrder];
 
 */

@interface EventSorter : NSObject
+ (EventSorter*)instance;
-(NSDictionary*)sortOrder;
@end
