//
//  Provider.h
//  NCSNavField
//
//  Created by John Dzak on 11/7/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Provider : NSManagedObject

@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * practiceNum;
@property (nonatomic, strong) NSString * addressOne;
@property (nonatomic, strong) NSString * unit;
@property (nonatomic, retain) NSNumber * recruited;

@end
