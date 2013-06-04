//
//  FormElementProtocol.h
//  NCSNavField
//
//  Created by Jacob Van Order on 6/3/13.
//  Copyright (c) 2013 Northwestern University. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FormElementProtocol <NSObject>

-(void)markAsRequired;
-(void)resetMarkAsRequired;

@end
