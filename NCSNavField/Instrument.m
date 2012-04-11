//
//  Instrument.m
//  NCSNavField
//
//  Created by John Dzak on 9/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Instrument.h"

@implementation Instrument

@dynamic instrumentId, name, responseSet, responseSetDict, instrumentTemplateId, instrumentTemplate, externalResponseSetId, event;

- (NUResponseSet*) responseSet {
    NSManagedObjectContext* moc = [NUResponseSet managedObjectContext];
    NSEntityDescription *desc = [NSEntityDescription entityForName:@"ResponseSet" inManagedObjectContext:moc];
    NSFetchRequest *req = [[[NSFetchRequest alloc] init] autorelease];
    
    [req setEntity:desc];
    
    NSPredicate *p = [NSPredicate predicateWithFormat:
                      @"uuid = %@", self.externalResponseSetId];
    
    [req setPredicate:p];
    
    NSError *error = nil;
    
    NSArray *array = [moc executeFetchRequest:req error:&error];
    
    NUResponseSet* rs = NULL;
    if (array != nil) {
        NSLog(@"fetched response set: %@", array);
        rs = [[array objectEnumerator] nextObject];
    } else {
        NSLog(@"Error during fetch");                
    }
    
    return rs;
}

- (void)setResponseSet:(NUResponseSet *)responseSet {
    self.externalResponseSetId = [responseSet valueForKey:@"uuid"];
}

- (NSDictionary*) responseSetDict {
    return self.responseSet.toDict;
}

@end
