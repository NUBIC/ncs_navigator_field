//
//  BlockBackground.h


#import <UIKit/UIKit.h>

@interface BlockBackground : UIWindow {
@private
    UIWindow *_previousKeyWindow;
}

+ (BlockBackground *) sharedInstance;

- (void)addToMainWindow:(UIView *)view;
- (void)reduceAlphaIfEmpty;
- (void)removeView:(UIView *)view;

@property (nonatomic, strong) UIImage *backgroundImage;
@property (nonatomic, readwrite) BOOL vignetteBackground;

@end
