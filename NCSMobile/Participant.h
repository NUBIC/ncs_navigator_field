//
//  Participant.h
//  NCSMobile
//
//  Created by John Dzak on 3/7/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface Participant : NSManagedObject

@property(nonatomic,retain) NSString* pId;

@property(nonatomic,retain) NSSet* persons;

@end
