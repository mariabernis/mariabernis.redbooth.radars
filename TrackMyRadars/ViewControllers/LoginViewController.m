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
#import "RadarListViewController.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@end



@implementation LoginViewController

#pragma mark - VC life cycle
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

#pragma mark - Actions
- (IBAction)loginButtonPressed:(id)sender {
    
    [[RedboothAPIClient sharedInstance] launchAuthorizationFlow];
}

- (void)handleAuthoriseCallback:(NSString *)code {
    
    [[RedboothAPIClient sharedInstance] authoriseWithCode:code
                                               completion:^(NSError *error) {
                                                   if (error) {
                                                       NSLog(@"😱 Auth error: %@", error);
                                                       return;
                                                   }
                                                   
                                                   UINavigationController *nav = [self.storyboard instantiateViewControllerWithIdentifier:@"RadarListNav"];
                                                   RadarListViewController *radarListVC = (RadarListViewController *)[nav topViewController];
                                                   radarListVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                                                   [self presentViewController:radarListVC animated:YES completion:nil];
                                                   
                                               }];
}

@end
