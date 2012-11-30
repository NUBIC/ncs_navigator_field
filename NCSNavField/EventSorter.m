//
//  EventSorter.m
//  NCSNavField
//
//  Created by Sam Hicks on 11/30/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "EventSorter.h"

#define CSV_FILE @"Event_Type_Sort_Order"

@interface EventSorter() {
    NSMutableDictionary *_dictionary;
}
-(id)init; //The client should not be calling this method directly so let's hide it.
-(void)dictionaryFromFile; //None of the client's business.
@end

static EventSorter *gInstance = NULL;

@implementation EventSorter

-(id)init {
    if ( self = [super init] ) {
        //We want to read from the file and create the dictionary on init.
        [self dictionaryFromFile];
    }
    return self;
}
-(NSDictionary*)sortOrder {
    //Lookup table is NSString*->NSNumber*
    return _dictionary;
}

+(EventSorter*)instance
{
    @synchronized(self)
    {
        if (gInstance == NULL)
            gInstance = [[self alloc] init];
    }
    return(gInstance);
}

-(void)dictionaryFromFile {
    _dictionary = [NSMutableDictionary new];
    NSError *error;
    NSString *fullPath = [[NSBundle mainBundle] pathForResource:CSV_FILE ofType:@"txt"];
    NSString *fileString = [NSString stringWithContentsOfFile:fullPath
                                                    encoding:NSUTF8StringEncoding error:&error];
    if ((nil == fileString)||(error != nil)) {
        //throw exception, this shouldn't happen.
        NSLog(@"%@",[error description]);
        [NSException raise:@"File IO issue in EventSorter" format:nil];
    }
    //fileString is good, so let's parse it.
    NSArray *rows = [fileString csvRows];
    for(NSArray *innerArray in rows)
    {
        //NSString*->NSNumber*
        NSNumber *n = [[[innerArray objectAtIndex:0] stringByTrimmingCharactersInSet:
                       [NSCharacterSet whitespaceCharacterSet]] toNumber];
        [_dictionary setObject:n forKey:[innerArray objectAtIndex:1]];
    }
}

@end
