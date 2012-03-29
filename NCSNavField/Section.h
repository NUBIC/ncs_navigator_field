//
//  Section.h
//  NCSNavField
//
//  Created by John Dzak on 9/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Row;
@interface Section : NSObject {
    NSArray *_rows;
    NSString *_name;
}

@property(nonatomic,retain) NSArray *rows;
@property(nonatomic,copy) NSString *name;

- (Section*)initWithRows:(id)row,...;
- (void)addRow:(Row*)row;
- (Section*)initWithName:(NSString*)name andRows:(id)row,...;

@end
