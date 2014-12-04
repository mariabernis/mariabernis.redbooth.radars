//
//  RadarListViewController.m
//  TrackMyRadars
//
//  Created by Maria Bernis on 03/12/14.
//  Copyright (c) 2014 mariabernis. All rights reserved.
//

#import "RadarListViewController.h"
#import "WizardOpEmailViewController.h"
#import "WizardRbOrganizationViewController.h"
#import "WizardDelegate.h"

@interface RadarListViewController ()<WizardDelegate>

@property (weak, nonatomic) IBOutlet UIView *noImportView;
@end


@implementation RadarListViewController

#pragma mark - VC life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Actions
- (IBAction)startImport:(id)sender {
    UINavigationController *navVC = [self.storyboard instantiateViewControllerWithIdentifier:@"WizardOneNav"];
    WizardOpEmailViewController *wizardEmailVC = (WizardOpEmailViewController *)[navVC topViewController];
    wizardEmailVC.delegate = self;
    [self presentViewController:navVC animated:YES completion:nil];
}

#pragma mark - WizardDelegate

@end
