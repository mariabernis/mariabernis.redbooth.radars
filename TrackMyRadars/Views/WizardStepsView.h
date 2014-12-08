//
//  WizardStepsView.h
//  TrackMyRadars
//
//  Created by Maria Bernis on 06/12/14.
//  Copyright (c) 2014 mariabernis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WizardStepsView : UIView

@property (nonatomic, assign) NSInteger step;

/* Designated initializer */
- (instancetype)initWithFrame:(CGRect)frame step:(NSInteger)step;

@end
