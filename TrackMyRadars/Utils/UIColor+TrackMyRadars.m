//
//  UIColor+TrackMyRadars.m
//  TrackMyRadars
//
//  Created by Maria Bernis on 03/12/14.
//  Copyright (c) 2014 mariabernis. All rights reserved.
//

#import "UIColor+TrackMyRadars.h"

@implementation UIColor (TrackMyRadars)

+ (UIColor *)redboothColor
{
    return [UIColor colorWithHue:1 saturation:0.853 brightness:0.886 alpha:1];
}

+ (UIColor *)redboothColorDarken
{
    return [UIColor colorWithHue:1 saturation:0.853 brightness:0.7 alpha:1];
}

+ (UIColor *)tmrMainColor
{
    return [UIColor flatWetAsphaltColor];
}

+ (UIColor *)tmrMainColorDarker
{
    return [UIColor flatMidnightBlueColor];
}

+ (UIColor *)tmrMainColorLighter
{
    return [UIColor colorWithHue:0.583 saturation:1 brightness:0.442 alpha:1];
}

+ (UIColor *)tmrMainColorWithAlpha:(CGFloat)alpha
{
    return [UIColor colorWithHue:0.583 saturation:0.445 brightness:0.368 alpha:alpha];
}

+ (UIColor *)tmrWhiteColor
{
    return [UIColor whiteColor];
}

+ (UIColor *)tmrTintColor
{
    return [UIColor flatCloudsColor];
}

+ (UIColor *)tmrLighterGrayColor
{
    return [UIColor flatCloudsColor];
}

+ (UIColor *)tmrLightMiddleGrayColor
{
    return [UIColor flatAsbestosColor];
}

+ (UIColor *)tmrDisabledColor
{
    return [UIColor flatSilverColor];
}

@end
