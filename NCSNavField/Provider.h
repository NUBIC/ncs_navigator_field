//
//  Provider.h
//  NCSNavField
//
//  Created by John Dzak on 11/7/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Provider : NSManagedObject

@property (nonatomic, retain) NSNumber * locationNum;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * practiceNum;
@property (nonatomic, retain) NSString * providerId;
@property (nonatomic, retain) NSNumber * recruited;

@end
