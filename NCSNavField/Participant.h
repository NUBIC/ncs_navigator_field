//
//  Participant.h
//  NCSNavField
//
//  Created by John Dzak on 3/7/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface Participant : NSManagedObject

@property(nonatomic,strong) NSString* pId;

@property(nonatomic,strong) NSSet* persons;

@end
