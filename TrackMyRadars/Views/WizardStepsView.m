//
//  WizardStepsView.m
//  TrackMyRadars
//
//  Created by Maria Bernis on 06/12/14.
//  Copyright (c) 2014 mariabernis. All rights reserved.
//

#import "WizardStepsView.h"
#import "UIColor+TrackMyRadars.h"

#define CIRCLE_WIDTH 35.0
#define LINE_HEIGHT 10.0
#define HORIZONTAL_MARGIN 35.0

@interface WizardStepsView ()
@property (nonatomic, assign) CGRect leftCircleFrame;
@property (nonatomic, assign) CGRect rightCircleFrame;
@property (nonatomic, assign) CGRect activeCircleFrame;
@end

@implementation WizardStepsView

- (instancetype)initWithFrame:(CGRect)frame step:(NSInteger)step
{
    self = [super initWithFrame:frame];
    if (self) {
        _step = step;
        [self setup];
    }
    return self;
}

- (void)setup {
    
    self.backgroundColor = [UIColor flatCloudsColor];
    
    CGFloat centerY = CGRectGetHeight(self.frame)/2;
    CGFloat circlesY = centerY - CIRCLE_WIDTH/2;
    self.leftCircleFrame = CGRectMake(HORIZONTAL_MARGIN,
                                  circlesY,
                                  CIRCLE_WIDTH,
                                  CIRCLE_WIDTH);
    self.rightCircleFrame = CGRectMake(CGRectGetWidth(self.frame) - HORIZONTAL_MARGIN - CIRCLE_WIDTH,
                                   circlesY,
                                   CIRCLE_WIDTH,
                                   CIRCLE_WIDTH);
    if (!self.step) {
        self.step = 1;
    }
    if (self.step == 1) {
        self.activeCircleFrame = self.leftCircleFrame;
    } else {
        self.activeCircleFrame = self.rightCircleFrame;
    }
    
    UILabel *numberLabel = [[UILabel alloc] initWithFrame:CGRectInset(self.activeCircleFrame, -5, -5)];
    numberLabel.font = [UIFont boldSystemFontOfSize:15.0];
    numberLabel.textColor = [UIColor whiteColor];
    numberLabel.textAlignment = NSTextAlignmentCenter;
    numberLabel.text = [NSString stringWithFormat:@"%li", self.step];
    
    CGFloat labelHeigh = 21.0;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, centerY - LINE_HEIGHT/2 - 3 - labelHeigh, CGRectGetWidth(self.frame), labelHeigh)];
    label.font = [UIFont systemFontOfSize:14.0];
    label.textColor = [UIColor flatSilverColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = [NSString stringWithFormat:@"Step %li of 2", self.step];
    
    [self addSubview:numberLabel];
    [self addSubview:label];
}


- (void)drawRect:(CGRect)rect {

    CGFloat centerY = CGRectGetHeight(rect)/2;
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    
    [[UIColor flatSilverColor] set];
    // Left circle
    UIBezierPath *leftCircle = [UIBezierPath bezierPathWithOvalInRect:self.leftCircleFrame];
    [bezierPath appendPath:leftCircle];
    [bezierPath fill];
    
    // Right circle
    UIBezierPath *rightCircle = [UIBezierPath bezierPathWithOvalInRect:self.rightCircleFrame];
    [bezierPath removeAllPoints];
    [bezierPath appendPath:rightCircle];
    [bezierPath fill];
    
    // Line in between
    [bezierPath removeAllPoints];
    [bezierPath moveToPoint:CGPointMake(HORIZONTAL_MARGIN + CIRCLE_WIDTH/2, centerY)];
    [bezierPath addLineToPoint:CGPointMake(CGRectGetWidth(rect) - HORIZONTAL_MARGIN - CIRCLE_WIDTH/2, centerY)];
    [bezierPath setLineWidth:LINE_HEIGHT];
    [bezierPath stroke];
    
    // Highlight circle
    [[UIColor flatWetAsphaltColor] set];
    [bezierPath removeAllPoints];
    
    CGRect stepCircleFrame = CGRectInset(self.activeCircleFrame, 3, 3);
    UIBezierPath *stepCircle = [UIBezierPath bezierPathWithOvalInRect:stepCircleFrame];
    [bezierPath appendPath:stepCircle];
    [bezierPath fill];
    
}


@end
