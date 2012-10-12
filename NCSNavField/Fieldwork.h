//
//  FieldWork.h
//  NCSNavField
//
//  Created by John Dzak on 3/14/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface Fieldwork : NSManagedObject

@property(weak, readonly) NSString *fieldworkId;

@property(nonatomic,strong) NSString* uri;

@property(nonatomic,strong) NSDate* retrievedDate;

@property(nonatomic,strong) NSSet* participants;

@property(nonatomic,strong) NSSet* contacts;

@property(nonatomic,strong) NSSet* instrumentTemplates;

+ (Fieldwork*)submission;

@end
