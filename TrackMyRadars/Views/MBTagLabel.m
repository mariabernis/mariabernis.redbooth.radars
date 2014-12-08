//
//  MBTagLabel.m
//  TrackMyRadars
//
//  Created by Maria Bernis on 07/12/14.
//  Copyright (c) 2014 mariabernis. All rights reserved.
//

#import "MBTagLabel.h"

@implementation MBTagLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}


- (void)commonInit {
    _padding = UIEdgeInsetsZero;
}


- (void)drawTextInRect:(CGRect)rect {
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.padding)];
}

- (CGSize)intrinsicContentSize {
    
    CGSize size = [super intrinsicContentSize];
    CGFloat adjustedW = size.width + self.padding.left + self.padding.right;
    CGFloat adjustedH = size.height + self.padding.top + self.padding.bottom;
    
    CGSize adjustedSize = CGSizeMake(adjustedW, adjustedH);
    
    return adjustedSize;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
