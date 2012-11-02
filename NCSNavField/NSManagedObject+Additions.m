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
    return [self copyObject:self withCopiedCache:[NSMutableDictionary new]];
//    return [self cloneInContext:[self managedObjectContext] withCopiedCache:[NSMutableDictionary new] exludeEntities:[NSArray arrayWithObject:[InstrumentTemplate entity]]];
}

- (NSManagedObject*)copyObject:(NSManagedObject*)object withCopiedCache:(NSMutableDictionary*)cache {
    NSManagedObjectContext* moc = self.managedObjectContext;
    
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
                        temp = [self copyObject:oldDestObject withCopiedCache:cache];
                    }
                    [newDestSet addObject:temp];
                }
                
                [newObject setValue:newDestSet forKey:key];

            } else {
                NSMutableSet *newDestSet = [NSMutableSet new];
                
                for (oldDestObject in [object valueForKey:key]) {
                    temp = [cache objectForKey:[oldDestObject objectID]];
                    if (!temp) {
                        temp = [self copyObject:oldDestObject withCopiedCache:cache];
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
                temp = [self copyObject:oldDestObject withCopiedCache:cache];
            }
            
            [newObject setValue:temp forKey:key];
        }
    }
    
    return newObject;
}

- (NSMutableDictionary*)lookup {
    return [NSMutableDictionary new];
}


//- (NSManagedObject *)cloneInContext:(NSManagedObjectContext *)context withCopiedCache:(NSMutableDictionary *)alreadyCopied exludeEntities:(NSArray *)namesOfEntitiesToExclude {
//    NSString *entityName = [[self entity] name];
//    
//    if ([namesOfEntitiesToExclude containsObject:entityName]) {
//        return nil;
//    }
//    
//    NSManagedObject *cloned = [alreadyCopied objectForKey:[self objectID]];
//    if (cloned != nil) {
//        return cloned;
//    }
//    
//    //create new object in data store
//    cloned = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:context];
//    [alreadyCopied setObject:cloned forKey:[self objectID]];
//    
//    //loop through all attributes and assign then to the clone
//    NSDictionary *attributes = [[NSEntityDescription entityForName:entityName inManagedObjectContext:context] attributesByName];
//    
//    for (NSString *attr in attributes) {
//        [cloned setValue:[self valueForKey:attr] forKey:attr];
//    }
//    
//    //Loop through all relationships, and clone them.
//    NSDictionary *relationships = [[NSEntityDescription entityForName:entityName inManagedObjectContext:context] relationshipsByName];
//    for (NSString *relName in [relationships allKeys]){
//        NSRelationshipDescription *rel = [relationships objectForKey:relName];
//        
//        NSString *keyName = rel.name;
//        if ([rel isToMany]) {
//            //get a set of all objects in the relationship
//            NSMutableSet *sourceSet = [self mutableSetValueForKey:keyName];
//            NSMutableSet *clonedSet = [cloned mutableSetValueForKey:keyName];
//            NSEnumerator *e = [sourceSet objectEnumerator];
//            NSManagedObject *relatedObject;
//            while ( relatedObject = [e nextObject]){
//                //Clone it, and add clone to set
//                NSManagedObject *clonedRelatedObject = [relatedObject cloneInContext:context withCopiedCache:alreadyCopied exludeEntities:namesOfEntitiesToExclude];
//                [clonedSet addObject:clonedRelatedObject];
//            }
//        }else {
//            NSManagedObject *relatedObject = [self valueForKey:keyName];
//            if (relatedObject != nil) {
//                NSManagedObject *clonedRelatedObject = [relatedObject cloneInContext:context withCopiedCache:alreadyCopied exludeEntities:namesOfEntitiesToExclude];
//                [cloned setValue:clonedRelatedObject forKey:keyName];
//            }
//        }
//    }
//    
//    return cloned;
//}

@end
