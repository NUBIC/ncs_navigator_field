//
//  NSManagedObject+Additions.h
//  NCSNavField
//
//  Created by John Dzak on 11/1/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (Additions)

- (NSManagedObject *)cloneAndignoreRelations:(NSArray*)ignoreRelations;

- (NSManagedObject *)cloneIntoManagedObjectContext:(NSManagedObjectContext*)moc;

+ (id)transient;

- (BOOL)isTransient;

@end
