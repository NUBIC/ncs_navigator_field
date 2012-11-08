//
//  SurveyContextGenerator.h
//  NCSNavField
//
//  Created by John Dzak on 11/8/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Provider;

@interface SurveyContextGenerator : NSObject {
    Provider* _provider;
}

@property(nonatomic,retain) Provider* provider;

- (id)initWithProvider:(Provider*)provider;

- (id)context;

@end
