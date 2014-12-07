//
//  RadarTaskCell.h
//  TrackMyRadars
//
//  Created by Maria Bernis on 07/12/14.
//  Copyright (c) 2014 mariabernis. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MBTagLabel;
@interface RadarTaskCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet MBTagLabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *radarTitleLabel;

@property (nonatomic, assign, getter=isImported) BOOL imported;

@end
