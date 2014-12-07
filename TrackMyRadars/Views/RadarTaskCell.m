//
//  RadarTaskCell.m
//  TrackMyRadars
//
//  Created by Maria Bernis on 07/12/14.
//  Copyright (c) 2014 mariabernis. All rights reserved.
//

#import "RadarTaskCell.h"
#import "UIColor+TrackMyRadars.h"
#import "MBTagLabel.h"

@implementation RadarTaskCell

- (void)awakeFromNib {
    // Initialization code
    CGFloat labelHeight = self.statusLabel.frame.size.height;
    self.statusLabel.layer.cornerRadius = labelHeight/2;
    self.statusLabel.layoutMargins = UIEdgeInsetsMake(0, 10, 0, 10);
    self.statusLabel.clipsToBounds = YES;
    
    self.statusLabel.padding = UIEdgeInsetsMake(0, 6, 0, 6);
}

- (void)setImported:(BOOL)imported {
    _imported = imported;
    if (imported) {
        self.numberLabel.textColor = [UIColor tmrLightMiddleGrayColor];
        self.statusLabel.textColor = [UIColor tmrTintColor];
        self.statusLabel.backgroundColor = [UIColor tmrMainColor];
        self.radarTitleLabel.textColor = [UIColor tmrMainColor];
    } else {
        self.numberLabel.textColor = [UIColor tmrDisabledColor];
        self.statusLabel.textColor = [UIColor tmrTintColor];
        self.statusLabel.backgroundColor = [UIColor tmrDisabledColor];
        self.radarTitleLabel.textColor = [UIColor tmrDisabledColor];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}



@end
