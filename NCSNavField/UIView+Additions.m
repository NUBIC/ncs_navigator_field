//
//  UIView+Additions.m
//  NCSNavField
//
//  Created by Sam Hicks on 10/26/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "UIView+Additions.h"

@implementation UIView (Additions)
-(void)postPopoverNotification {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"EndEditingNotification" object:nil];
}
-(void)registerForPopoverNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissKeyboard) name:@"EndEditingNotification" object:nil];
}
-(void)dismissKeyboard {
    /*if([self.superview isKindOfClass:[UIView class]]) {
        [self.superview endEditing:YES];
    }*/
    [self endEditing:YES];
}
@end
