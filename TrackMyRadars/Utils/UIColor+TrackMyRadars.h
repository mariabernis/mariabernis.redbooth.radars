//
//  UIColor+TrackMyRadars.h
//  TrackMyRadars
//
//  Created by Maria Bernis on 03/12/14.
//  Copyright (c) 2014 mariabernis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIColor+FlatColors/UIColor+FlatColors.h>

@interface UIColor (TrackMyRadars)

+ (UIColor *)redboothColor;
+ (UIColor *)redboothColorDarken;
+ (UIColor *)tmrMainColor;
+ (UIColor *)tmrMainColorDarker;
+ (UIColor *)tmrMainColorLighter;
+ (UIColor *)tmrMainColorWithAlpha:(CGFloat)alpha;
+ (UIColor *)tmrWhiteColor;
+ (UIColor *)tmrTintColor;
+ (UIColor *)tmrLighterGrayColor;
+ (UIColor *)tmrLightMiddleGrayColor;
+ (UIColor *)tmrDisabledColor;

@end
