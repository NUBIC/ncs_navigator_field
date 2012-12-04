//
//  EventSorter.h
//  NCSNavField
//
//  Created by Sam Hicks on 11/30/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Event;

/*

 Event Sort is used to determine the order in which events
 should be performed
 
 Use this something like:
    [EventSorter compareEvent:a toEvent:b];
 
 */

@interface EventSorter : NSObject

+ (NSComparisonResult)compareEvent:(Event*)a toEvent:(Event*)b;
    
@end
