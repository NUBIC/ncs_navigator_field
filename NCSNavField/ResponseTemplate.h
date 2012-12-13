//
//  ResponseTemplate.h
//  NCSNavField
//
//  Created by John Dzak on 12/13/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ResponseTemplate : NSManagedObject

@property (nonatomic, retain) NSString * qref;
@property (nonatomic, retain) NSString * aref;
@property (nonatomic, retain) NSString * value;
@property (nonatomic, retain) NSString * surveyId;

@end
