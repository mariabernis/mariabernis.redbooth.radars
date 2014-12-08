//
//  ViewController.m
//  TrackMyRadars
//
//  Created by Maria Bernis on 03/12/14.
//  Copyright (c) 2014 mariabernis. All rights reserved.
//

#import "LoginViewController.h"
#import "UIColor+TrackMyRadars.h"
#import "UIButton+TrackMyRadars.h"
#import <PQFCustomLoaders/PQFCustomLoaders.h>
#import "RedboothAPIClient.h"
#import "RadarListViewController.h"

@interface LoginViewController ()
@property (nonatomic, strong) PQFCirclesInTriangle *loader;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UILabel *explanationLabel;
@end


@implementation LoginViewController

-(PQFCirclesInTriangle *)loader {
    if (!_loader) {
        _loader = [[PQFCirclesInTriangle alloc] initLoaderOnView:self.view];
        _loader.backgroundColor = [UIColor tmrMainColorWithAlpha:0.8];
        _loader.loaderColor = [UIColor tmrTintColor];
        // Fix center
        _loader.center = CGPointMake(self.view.center.x, self.view.center.y - 64);
    }
    return _loader;
}

#pragma mark - VC life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor tmrLighterGrayColor];
    self.titleLabel.textColor = [UIColor tmrMainColor];
    self.explanationLabel.textColor = [UIColor tmrMainColor];
    [self.loginButton redboothLoginStyle];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Actions
- (IBAction)loginButtonPressed:(id)sender {
    
    [[RedboothAPIClient sharedInstance] launchAuthorizationFlow];
}

- (void)handleAuthoriseCallback:(NSString *)code {
    
    [self.loader show];
    [[RedboothAPIClient sharedInstance] authoriseWithCode:code
                                               completion:^(NSError *error) {
                                                   
                                                   [self.loader hide];
                                                   if (error) {
                                                       NSLog(@"😱 Auth error: %@", error);
                                                       return;
                                                   }
                                                   
                                                   UINavigationController *nav = [self.storyboard instantiateViewControllerWithIdentifier:@"RadarListNav"];
                                                   nav.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                                                   [self presentViewController:nav animated:YES completion:nil];
                                                   
                                               }];
}

@end
