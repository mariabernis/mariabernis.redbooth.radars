//
//  UIButton+TrackMyRadars.m
//  TrackMyRadars
//
//  Created by Maria Bernis on 07/12/14.
//  Copyright (c) 2014 mariabernis. All rights reserved.
//

#import "UIButton+TrackMyRadars.h"
#import "UIColor+TrackMyRadars.h"
#import "UIImage+Color.h"

@implementation UIButton (TrackMyRadars)

- (void)tmrStyle {
    
    CALayer *layer = self.layer;
    layer.borderColor = [UIColor tmrMainColorLighter].CGColor;
    layer.borderWidth = 1.0;
    layer.cornerRadius = 3.0;
    self.clipsToBounds = YES;
    
    [self setBackgroundImage:[UIImage mbc_imageWithColor:[UIColor tmrWhiteColor]] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage mbc_imageWithColor:[UIColor tmrWhiteColor]] forState:UIControlStateDisabled];
    [self setBackgroundImage:[UIImage mbc_imageWithColor:[UIColor tmrMainColorLighter]] forState:UIControlStateHighlighted];
    [self setTitleColor:[UIColor tmrMainColorLighter] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor tmrDisabledColor] forState:UIControlStateDisabled];
    [self setTitleColor:[UIColor tmrTintColor] forState:UIControlStateHighlighted];
}

- (void)redboothLoginStyle {
    
    [self setImage:[UIImage imageNamed:@"ic_redbooth_white_30"] forState:UIControlStateNormal];
    [self setImage:[UIImage imageNamed:@"ic_redbooth_white_30"] forState:UIControlStateHighlighted];
    [self setBackgroundImage:[UIImage mbc_imageWithColor:[UIColor redboothColor]] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage mbc_imageWithColor:[UIColor redboothColorDarken]] forState:UIControlStateHighlighted];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    CGFloat spacing = 15;
    self.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, spacing);
    self.titleEdgeInsets = UIEdgeInsetsMake(0, spacing, 0, 0);
}

@end
