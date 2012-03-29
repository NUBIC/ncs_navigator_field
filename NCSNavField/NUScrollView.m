//
//  AutoSizingScrollView.m
//  NCSNavField
//
//  Created by John Dzak on 11/28/11.
//
// This 
//
#import "NUScrollView.h"

@implementation NUScrollView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.scrollEnabled = YES;
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.scrollEnabled = YES;
    }
    return self;    
}

- (void)didAddSubview:(UIView *)subview {
    CGRect contentRect = CGRectZero;
    for (UIView *sv in self.subviews) {
        contentRect = CGRectUnion(contentRect, sv.frame);
    }
    self.contentSize = contentRect.size;;
}

//- (void)didMoveToSuperview {
//    self.frame = CGRectMake(0, 0, self.superview.frame.size.width, self.superview.frame.size.height);
//}
                           
@end
