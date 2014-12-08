//
//  WizardRbOrganizationViewController.h
//  TrackMyRadars
//
//  Created by Maria Bernis on 04/12/14.
//  Copyright (c) 2014 mariabernis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WizardDelegate.h"

@interface WizardRbOrganizationViewController : UIViewController

@property (nonatomic, weak) id<WizardDelegate> delegate;
@property (nonatomic, strong) NSString *opEmail;

@end
