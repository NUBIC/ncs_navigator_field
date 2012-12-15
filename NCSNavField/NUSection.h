//
//  NUSection.h
//  NCSNavField
//
//  Created by John Dzak on 12/14/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NUSection : NSObject {
    NSString* _title;
    NSArray* _questions;
}

@property(nonatomic,retain) NSString* title;

@property(nonatomic,retain) NSArray* questions;

- (id)initWithDictionary:(NSDictionary*)sectionDict;

@end
