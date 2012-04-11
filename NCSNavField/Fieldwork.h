//
//  FieldWork.h
//  NCSNavField
//
//  Created by John Dzak on 3/14/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface Fieldwork : NSManagedObject

@property(readonly) NSString *fieldworkId;

@property(nonatomic,retain) NSString* uri;

@property(nonatomic,retain) NSDate* retrievedDate;

@property(nonatomic,retain) NSSet* participants;

@property(nonatomic,retain) NSSet* contacts;

@property(nonatomic,retain) NSSet* instrumentTemplates;

@end
