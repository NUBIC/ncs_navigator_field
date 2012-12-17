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
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center postNotificationName:@"EndEditingNotification" object:nil];
}

-(void)registerForPopoverNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissKeyboard) name:@"EndEditingNotification" object:nil];
}

-(void)dismissKeyboard {
    if([self respondsToSelector:@selector(endEditing:)])
        [self endEditing:YES];
    else
        NSLog(@"Does not respond to selector dismissKeyboard.");
}

-(void)dumpViews:(NSString*)text indent:(NSString*)indent {
    Class cl = [self class];
    NSString *classDescription = [cl description];
    while ([cl superclass])
    {
        cl = [cl superclass];
        classDescription = [classDescription stringByAppendingFormat:@":%@", [cl description]];
    }
    
    if ([text compare:@""] == NSOrderedSame)
        NSLog(@"%@ %@ tag:%d", classDescription, NSStringFromCGRect(self.frame),self.tag);
    else
        NSLog(@"%@ %@ %@ tag:%d", text, classDescription, NSStringFromCGRect(self.frame),self.tag);
    
    for (NSUInteger i = 0; i < [self.subviews count]; i++)
    {
        UIView *subView = [self.subviews objectAtIndex:i];
        NSString *newIndent = [[NSString alloc] initWithFormat:@"  %@", indent];
        NSString *msg = [[NSString alloc] initWithFormat:@"%@%d: ", newIndent, i];
        [subView dumpViews:msg indent:newIndent];
    }
}
@end
