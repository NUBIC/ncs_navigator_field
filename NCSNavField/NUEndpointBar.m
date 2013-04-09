 //
//  NUEndpointBar.m
//  NCSNavField
//
//  Created by Jacob Van Order on 2/18/13.
//  Copyright (c) 2013 Northwestern University. All rights reserved.
//

#import "NUEndpointBar.h"

@interface NUEndpointBar ()

@end

@implementation NUEndpointBar

#pragma mark delegate methods

#pragma mark customization

#pragma mark prototyping

#pragma mark stock code


- (id)initWithFrame:(CGRect)frame
{
    self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
    if (self) {
        self.frame = frame;
        // Initialization code
    }
    return self;
}

-(void)awakeFromNib {
    self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"endPointBarBackground"]];
    [self.endpointBarButton setBackgroundImage: [[UIImage imageNamed:@"buttonBackground"] resizableImageWithCapInsets:UIEdgeInsetsMake(17.0f, 7.0f, 0.0f, 16.0f)] forState:UIControlStateNormal];
    [self.endpointBarButton setBackgroundImage: [[UIImage imageNamed:@"buttonBackgroundDown"] resizableImageWithCapInsets:UIEdgeInsetsMake(17.0f, 7.0f, 0.0f, 16.0f)] forState:UIControlStateHighlighted];
    self.endpointBarButton.tintColor = [UIColor blackColor];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
