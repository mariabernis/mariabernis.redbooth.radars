//
//  ViewController.m
//  TrackMyRadars
//
//  Created by Maria Bernis on 03/12/14.
//  Copyright (c) 2014 mariabernis. All rights reserved.
//

#import "LoginViewController.h"
#import "UIColor+TrackMyRadars.h"
#import "UIImage+Color.h"
#import <PQFCustomLoaders/PQFCirclesInTriangle.h>
#import "RedboothAPIClient.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@end



@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.loginButton setBackgroundImage:[UIImage mbc_imageWithColor:[UIColor redboothColor]] forState:UIControlStateNormal];
    [self.loginButton setBackgroundImage:[UIImage mbc_imageWithColor:[UIColor redboothColorDarken]] forState:UIControlStateHighlighted];
    CGFloat spacing = 15;
    self.loginButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, spacing);
    self.loginButton.titleEdgeInsets = UIEdgeInsetsMake(0, spacing, 0, 0);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)loginButtonPressed:(id)sender {
    
    [[RedboothAPIClient sharedInstance] authorize];
}

@end
