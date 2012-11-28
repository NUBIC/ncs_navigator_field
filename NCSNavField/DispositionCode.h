//
//  DispositionCode.h
//  NCSNavField
//
//  Created by Sam Hicks on 11/27/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DispositionCode : NSManagedObject

@property (nonatomic, retain) NSString * categoryCode;
@property (nonatomic, retain) NSString * disposition;
@property (nonatomic, retain) NSNumber * finalCategory;
@property (nonatomic, retain) NSString * finalCode;
@property (nonatomic, retain) NSString * interimCode;
@property (nonatomic, retain) NSString * subCategory;

@end
