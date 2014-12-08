//
//  UIView+TrackMyRadars.m
//  TrackMyRadars
//
//  Created by Maria Bernis on 07/12/14.
//  Copyright (c) 2014 mariabernis. All rights reserved.
//

#import "UIView+TrackMyRadars.h"
#import "UIColor+TrackMyRadars.h"

@implementation UIView (TrackMyRadars)
- (void)tmrFieldBckStyle {
    
    self.layer.borderColor = [UIColor tmrLightMiddleGrayColor].CGColor;
    self.layer.borderWidth = 1.0;
    self.layer.cornerRadius = 2.0;
    self.backgroundColor = [UIColor tmrWhiteColor];
}
@end
