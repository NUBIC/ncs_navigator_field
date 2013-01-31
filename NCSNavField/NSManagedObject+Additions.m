//
//  NSManagedObject+Additions.m
//  NCSNavField
//
//  Created by John Dzak on 11/1/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "NSManagedObject+Additions.h"
#import "InstrumentTemplate.h"

@implementation NSManagedObject (Additions)

- (NSManagedObject *)clone {
    return [self copyObject:self withCopiedCache:[NSMutableDictionary new] andManagedObjectContext:self.managedObjectContext];
}

- (NSManagedObject *)cloneIntoManagedObjectContext:(NSManagedObjectContext*)moc {
    return [self copyObject:self withCopiedCache:[NSMutableDictionary new] andManagedObjectContext:moc];
}

- (NSManagedObject*)copyObject:(NSManagedObject*)object withCopiedCache:(NSMutableDictionary*)cache andManagedObjectContext:(NSManagedObjectContext*)moc {   
    NSString *entityName = [[object entity] name];
    
    NSManagedObject *newObject = [NSEntityDescription
                                  insertNewObjectForEntityForName:entityName
                                  inManagedObjectContext:moc];
    [cache setObject:newObject forKey:[object objectID]];
    
    NSArray *attKeys = [[[object entity] attributesByName] allKeys];
    NSDictionary *attributes = [object dictionaryWithValuesForKeys:attKeys];
    
    [newObject setValuesForKeysWithDictionary:attributes];
    
    id oldDestObject = nil;
    id temp = nil;
    NSDictionary *relationships = [[object entity] relationshipsByName];
    for (NSString *key in [relationships allKeys]) {
        
        NSRelationshipDescription *desc = [relationships valueForKey:key];
        
        if ([desc isToMany]) {
            if ([desc isOrdered]) {
                NSMutableOrderedSet *newDestSet = [NSMutableOrderedSet new];
                
                for (oldDestObject in [object valueForKey:key]) {
                    temp = [cache objectForKey:[oldDestObject objectID]];
                    if (!temp) {
                        temp = [self copyObject:oldDestObject withCopiedCache:cache andManagedObjectContext:moc];
                    }
                    [newDestSet addObject:temp];
                }
                
                [newObject setValue:newDestSet forKey:key];

            } else {
                NSMutableSet *newDestSet = [NSMutableSet new];
                
                for (oldDestObject in [object valueForKey:key]) {
                    temp = [cache objectForKey:[oldDestObject objectID]];
                    if (!temp) {
                        temp = [self copyObject:oldDestObject withCopiedCache:cache andManagedObjectContext:moc];
                    }
                    [newDestSet addObject:temp];
                }
                
                [newObject setValue:newDestSet forKey:key];                
            }
            
            
        } else {
            oldDestObject = [object valueForKey:key];
            if (!oldDestObject) continue;
            
            temp = [cache objectForKey:[oldDestObject objectID]];
            if (!temp) {
                temp = [self copyObject:oldDestObject withCopiedCache:cache andManagedObjectContext:moc];
            }
            
            [newObject setValue:temp forKey:key];
        }
    }
    
    return newObject;
}

- (NSMutableDictionary*)lookup {
    return [NSMutableDictionary new];
}

+ (id)transient {
    NSEntityDescription *entity = [self entity];
    id object = [[self alloc] initWithEntity:entity insertIntoManagedObjectContext:nil];
    return object;
}

- (BOOL)isTransient {
    return [self.managedObjectContext isEqual:nil];
}

@end
