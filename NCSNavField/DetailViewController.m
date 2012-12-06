//
//  DetailViewController.m
//  NCSNavField
//
//  Created by Sam Hicks on 12/5/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController
@synthesize text=_text;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
//Set the 'title' of the view. This should be the "take-home" issue that help desk should see.
-(void)setHeader:(NSString *)str
{
    title.text = str;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
     tv.text = _text;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
