//
//  WizardStepsView.m
//  TrackMyRadars
//
//  Created by Maria Bernis on 06/12/14.
//  Copyright (c) 2014 mariabernis. All rights reserved.
//

#import "WizardStepsView.h"
#import "UIColor+TrackMyRadars.h"

#define CIRCLE_WIDTH 26.0
#define LINE_HEIGHT 7.0


@interface WizardStepsView ()

@end


@implementation WizardStepsView
{
    CGFloat _centerY;
    CGFloat _horizontalMargin;
    CGRect _leftCircleFrame;
    CGRect _rightCircleFrame;
    CGRect _activeCircleFrame;
}

- (instancetype)initWithFrame:(CGRect)frame step:(NSInteger)step
{
    self = [super initWithFrame:frame];
    if (self) {
        _step = step;
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.backgroundColor = [UIColor tmrLighterGrayColor];
    _horizontalMargin = (CGRectGetWidth([UIScreen mainScreen].bounds)/3)/2;
    
    _centerY = CGRectGetHeight(self.frame)/2 + 6;
    CGFloat circlesY = _centerY - CIRCLE_WIDTH/2;
    _leftCircleFrame = CGRectMake(_horizontalMargin,
                                  circlesY,
                                  CIRCLE_WIDTH,
                                  CIRCLE_WIDTH);
    _rightCircleFrame = CGRectMake(CGRectGetWidth(self.frame) - _horizontalMargin - CIRCLE_WIDTH,
                                   circlesY,
                                   CIRCLE_WIDTH,
                                   CIRCLE_WIDTH);
    if (!self.step) {
        self.step = 1;
    }
    if (self.step == 1) {
        _activeCircleFrame = _leftCircleFrame;
    } else {
        _activeCircleFrame = _rightCircleFrame;
    }
    
    // Number label
    UILabel *numberLabel = [[UILabel alloc] initWithFrame:CGRectInset(_activeCircleFrame, -5, -5)];
    numberLabel.font = [UIFont boldSystemFontOfSize:CIRCLE_WIDTH/2];
    numberLabel.textColor = [UIColor tmrTintColor];
    numberLabel.textAlignment = NSTextAlignmentCenter;
    numberLabel.text = [NSString stringWithFormat:@"%li", (long)self.step];
    
    // Step x of 2 label
    CGFloat labelHeigh = 21.0;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, _centerY - LINE_HEIGHT/2 - 3 - labelHeigh, CGRectGetWidth(self.frame), labelHeigh)];
    label.font = [UIFont systemFontOfSize:14.0];
    label.textColor = [UIColor tmrDisabledColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = [NSString stringWithFormat:@"Step %li of 2", (long)self.step];
    
    // Step icon
    NSString *icon = nil;
    CGFloat iconViewHeight = CIRCLE_WIDTH + 4;
    CGFloat margin = 15.0;
    CGRect iconViewFrame;
    if (self.step == 1) {
        icon = @"ic_bug_grey_70";
        iconViewFrame = CGRectMake(CGRectGetMinX(_leftCircleFrame) - margin - iconViewHeight,
                                   _centerY - iconViewHeight/2,
                                   iconViewHeight,
                                   iconViewHeight);
    } else {
        icon = @"ic_redbooth_grey_70";
        iconViewFrame = CGRectMake(CGRectGetMaxX(_rightCircleFrame) + margin,
                                   _centerY - iconViewHeight/2,
                                   iconViewHeight,
                                   iconViewHeight);
    }
    
    UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:icon]];
    iconView.frame = iconViewFrame;
    
    [self addSubview:numberLabel];
    [self addSubview:label];
    [self addSubview:iconView];
}


- (void)drawRect:(CGRect)rect
{
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    
    [[UIColor tmrDisabledColor] set];
    // Left circle
    UIBezierPath *leftCircle = [UIBezierPath bezierPathWithOvalInRect:_leftCircleFrame];
    [bezierPath appendPath:leftCircle];
    [bezierPath fill];
    
    // Right circle
    UIBezierPath *rightCircle = [UIBezierPath bezierPathWithOvalInRect:_rightCircleFrame];
    [bezierPath removeAllPoints];
    [bezierPath appendPath:rightCircle];
    [bezierPath fill];
    
    // Line in between
    [bezierPath removeAllPoints];
    [bezierPath moveToPoint:CGPointMake(_horizontalMargin + CIRCLE_WIDTH/2, _centerY)];
    [bezierPath addLineToPoint:CGPointMake(CGRectGetWidth(rect) - _horizontalMargin - CIRCLE_WIDTH/2, _centerY)];
    [bezierPath setLineWidth:LINE_HEIGHT];
    [bezierPath stroke];
    
    // Highlight circle
    [[UIColor tmrMainColor] set];
    [bezierPath removeAllPoints];
    
    CGRect stepCircleFrame = CGRectInset(_activeCircleFrame, 3, 3);
    UIBezierPath *stepCircle = [UIBezierPath bezierPathWithOvalInRect:stepCircleFrame];
    [bezierPath appendPath:stepCircle];
    [bezierPath fill];
    
}


@end
