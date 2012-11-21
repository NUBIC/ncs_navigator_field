//
//  MdesCode.m
//  NCSNavField
//
//  Created by Sam Hicks on 11/19/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "MdesCode.h"


@implementation MdesCode

@dynamic displayText;
@dynamic listName;
@dynamic localCode;

+(NSArray*)retrieveAllObjectsForListName:(NSString*)listName
{
    NSManagedObjectContext* moc = [RKObjectManager sharedManager].objectStore.managedObjectContextForCurrentThread;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"listName == %@", listName];
    [request setEntity:[NSEntityDescription entityForName:@"MdesCode" inManagedObjectContext:moc]];
    [request setPredicate:predicate];
   
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                       initWithKey:@"localCode" ascending:YES];
    [request setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    NSError *error = nil;
    NSMutableArray *results = [[moc executeFetchRequest:request error:&error] mutableCopy];
    //We should do some error handing here based on anything returned from error.
    
    int nIdx = -1;
    for(int i=0;i<[results count];i++) {
        MdesCode *code = [results objectAtIndex:i];
        if([code.localCode isEqualToNumber:[NSNumber numberWithInt:-4]]) {
            nIdx = i;
            break;
        }
    }
    if(nIdx>=0)
        [results removeObjectAtIndex:nIdx];
    return results;
}
-(NSString*)value {
    return [self.localCode stringValue];
}

-(NSString*)text {
    return self.displayText;
}

+ (NSArray*)all {
    NSManagedObjectContext* moc = [RKObjectManager sharedManager].objectStore.managedObjectContextForCurrentThread;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"MdesCode" inManagedObjectContext:moc]];
    
    NSError *error = nil;
    NSArray *results = [moc executeFetchRequest:request error:&error];
    return results;
}
@end
