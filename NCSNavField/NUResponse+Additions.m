//
//  NUResponse+Additions.m
//  NCSNavField
//
//  Created by John Dzak on 10/2/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "NUResponse+Additions.h"

@implementation NUResponse (Additions)

+ (NUResponse*)transient {
    NSDictionary* entities = [[[[NSManagedObjectContext contextForCurrentThread] persistentStoreCoordinator] managedObjectModel] entitiesByName];
    NSEntityDescription *entity = [entities objectForKey:@"Response"];
    id object = [[self alloc] initWithEntity:entity insertIntoManagedObjectContext:nil];
    return object;
}

@end
