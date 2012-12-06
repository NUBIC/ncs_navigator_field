//
//  DetailViewController.h
//  NCSNavField
//
//  Created by Sam Hicks on 12/5/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController <UITextViewDelegate> {
    IBOutlet UIView *view;
    IBOutlet UITextView *tv;
    IBOutlet UILabel *title;
    NSString *_text;
}
@property(nonatomic,retain) NSString *text;
-(void)setHeader:(NSString *)str;

@end
