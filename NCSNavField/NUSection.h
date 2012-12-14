//
//  NUSection.h
//  NCSNavField
//
//  Created by John Dzak on 12/14/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NUSection : NSObject {
    NSDictionary* _sectionDictionary;
}

@property(nonatomic,retain) NSDictionary* sectionDictionary;

- (id)initWithSectionDictionary:(NSDictionary*)sectionDict;

- (NSString*)title;

- (NSArray*)questions;

@end
