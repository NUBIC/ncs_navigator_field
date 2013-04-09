//
//  NUEndpointCollectionViewCell.h
//  NCSNavField
//
//  Created by Jacob Van Order on 2/14/13.
//  Copyright (c) 2013 Northwestern University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NUEndpointCollectionViewCell : UICollectionViewCell

-(void)loadCellDataFromEndpoint:(NUEndpoint *)endpoint;

@end
