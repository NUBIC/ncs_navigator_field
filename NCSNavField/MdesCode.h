//
//  MdesCode.h
//  NCSNavField
//
//  Created by Sam Hicks on 11/19/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <MRCEnumerable.h>

@interface MdesCode : NSManagedObject

@property (nonatomic, retain) NSString * displayText;
@property (nonatomic, retain) NSString * listName;
@property (nonatomic, retain) NSNumber *localCode;

+(NSArray*)retrieveAllObjectsForListName:(NSString*)listName;
+(NSArray*)all;
@end
