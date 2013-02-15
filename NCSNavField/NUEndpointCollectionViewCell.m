//
//  NUEndpointCollectionViewCell.m
//  NCSNavField
//
//  Created by Jacob Van Order on 2/14/13.
//  Copyright (c) 2013 Northwestern University. All rights reserved.
//

#import "NUEndpointCollectionViewCell.h"

#import <QuartzCore/QuartzCore.h>

#import "NUEndpoint.h"

@interface NUEndpointCollectionViewCell ()

@property (nonatomic, strong) IBOutlet UILabel *endpointLabel;
@property (strong, nonatomic) IBOutlet UIImageView *endpointImageView;

@end

@implementation NUEndpointCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([NUEndpointCollectionViewCell class]) owner:nil options:nil] lastObject];
    if (self) {
        self.layer.masksToBounds = NO;
        self.layer.shadowPath = [[UIBezierPath bezierPathWithRoundedRect:CGRectMake(0.0f, 0.0f, frame.size.width, frame.size.height) cornerRadius:10.0f] CGPath];
        self.layer.shadowColor = [[UIColor blackColor] CGColor];
        self.layer.shadowOpacity = 0.7;
        self.layer.shadowOffset = CGSizeMake(0.0f, 7.0f);
        self.layer.shadowRadius = 3.0f;
    }
    return self;
}

-(void)awakeFromNib {
    self.layer.masksToBounds = NO;
    self.layer.shadowPath = [[UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:10.0f] CGPath];
    self.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.layer.shadowOpacity = 0.7;
    self.layer.shadowOffset = CGSizeMake(0.0f, 7.0f);
    self.layer.shadowRadius = 3.0f;
}

-(void)drawRect:(CGRect)rect {
    UIBezierPath *fillPath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:10.0f];
    [[UIColor whiteColor] set];
    [fillPath fill];
    
    UIBezierPath *strokePath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(rect.origin.x + 5, rect.origin.y + 5, rect.size.width - 10, rect.size.height - 10) cornerRadius:6.0f];
    [strokePath setLineWidth:3.0f];
    [[UIColor lightGrayColor] set];
    [strokePath stroke];
}

-(id)init {
    self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([NUEndpointCollectionViewCell class]) owner:nil options:nil] lastObject];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)loadCellDataFromEndpoint:(NUEndpoint *)endpoint {
    self.endpointLabel.text = endpoint.name;
    self.endpointImageView.image = endpoint.endpointImage;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imageUpdated:) name:ENDPOINT_IMAGE_DOWNLOADED object:nil];
    if (endpoint.endpointImage == nil) {
        UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self addSubview:spinner];
        spinner.tag = 99;
        spinner.center = self.endpointImageView.center;
        [spinner startAnimating];
    }
}

-(void)prepareForReuse {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ENDPOINT_IMAGE_DOWNLOADED object:nil];
}

-(void)imageUpdated:(NSNotification *)note {
    NUEndpoint *endpoint = note.object;
    NSDictionary *userInfo = note.userInfo;
    if ([userInfo[@"name"] isEqualToString:self.endpointLabel.text]) {
        self.endpointImageView.image = endpoint.endpointImage;
        [[self viewWithTag:99] removeFromSuperview];
    }
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ENDPOINT_IMAGE_DOWNLOADED object:nil];
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
