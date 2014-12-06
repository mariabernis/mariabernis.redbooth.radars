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
#import "RadarsImportManager.h"
#import <PQFCustomLoaders/PQFCustomLoaders.h>

@interface RadarListViewController ()<WizardDelegate>

@property (nonatomic, strong) RadarsImportManager *importManager;
@property (nonatomic, strong) PQFCirclesInTriangle *loader;

@property (weak, nonatomic) IBOutlet UIView *noImportView;
@end


@implementation RadarListViewController

- (PQFCirclesInTriangle *)loader {
    if (!_loader) {
        _loader = [[PQFCirclesInTriangle alloc] initLoaderOnView:self.view];
        _loader.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.4];
        _loader.loaderColor = [UIColor flatPeterRiverColor];
    }
    return _loader;
}

#pragma mark - VC life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
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
- (void)wizardDidFinishWithOpEmail:(NSString *)email
                    organizationId:(NSInteger)organizationId {
    
    self.importManager = [[RadarsImportManager alloc] initWithOpEmail:email andOrganizationId:organizationId];
    [self.importManager importRadarsWithTemporaryContent:^(NSArray *tempRadars) {
        
    }
                                                progress:^(NSUInteger index, RadarTask *importedRadar) {
                                                    
                                                }
                                              completion:^(NSArray *importedRadars, NSError *error) {
                                                  
                                              }];
}

@end
