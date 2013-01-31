//
//  NUAnswer.h
//  NCSNavField
//
//  Created by John Dzak on 1/31/13.
//  Copyright (c) 2013 Northwestern University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NUQuestion;

@interface NUAnswer : NSManagedObject

@property (nonatomic, retain) NSString * uuid;
@property (nonatomic, retain) NSString * referenceIdentifier;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NUQuestion *question;

#pragma mark - Class Methods

+ (NUAnswer*)transientWithDictionary:(NSDictionary*)dict;

@end
