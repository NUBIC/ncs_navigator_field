//
//  FieldWork.h
//  NCSMobile
//
//  Created by John Dzak on 3/14/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface FieldWork : NSManagedObject

@property(readonly, getter = fieldWordId) NSString *fieldWorkId;

@property(nonatomic,retain) NSString* uri;

@property(nonatomic,retain) NSDate* retrievedDate;

@property(nonatomic,retain) NSSet* participants;

@property(nonatomic,retain) NSSet* contacts;

@property(nonatomic,retain) NSSet* instrumentTemplates;

@end
