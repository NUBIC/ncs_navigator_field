//
//  ChangeHandler.h
//  NCSNavField
//
//  Created by John Dzak on 12/5/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChangeHandler : NSObject {
    id _object;
    SEL _field;
}

@property(nonatomic,strong) id object;
@property(nonatomic) SEL field;

- (id) initWithObject:(id)object field:(SEL)field;
- (void) updatedValue:(id)value;
@end
