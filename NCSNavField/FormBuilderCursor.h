//
//  FormBuilderCursor.h
//  NCSNavField
//
//  Created by John Dzak on 12/4/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FormBuilderCursor : NSObject {
    CGFloat _x, _y;
}

@property(nonatomic) CGFloat x;
@property(nonatomic) CGFloat y;

- (void) addNewLine;

@end
