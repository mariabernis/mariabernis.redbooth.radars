//
//  WizardOpEmailViewController.m
//  TrackMyRadars
//
//  Created by Maria Bernis on 04/12/14.
//  Copyright (c) 2014 mariabernis. All rights reserved.
//

#import "WizardOpEmailViewController.h"
#import "WizardRbOrganizationViewController.h"
#import "MBCheck.h"

@interface WizardOpEmailViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *opEmailField;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@end

@implementation WizardOpEmailViewController

#pragma mark - VC life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.nextButton.enabled = NO;
    self.opEmailField.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.title = @"Import radars";
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationItem.title = @"";
}

#pragma mark - Actions
- (IBAction)dismissKeyboardIfShowing:(UITapGestureRecognizer *)sender {
    if ([self.opEmailField isFirstResponder]) {
        [self.opEmailField resignFirstResponder];
    }
}

- (IBAction)dismissWizard:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Helpers


#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"WizardTwoSegue"]) {
        WizardRbOrganizationViewController *wizardTwoVC = segue.destinationViewController;
        wizardTwoVC.delegate = self.delegate;
        wizardTwoVC.opEmail = self.opEmailField.text;
    }
}


#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField != self.opEmailField) {
        return;
    }
    
    self.nextButton.enabled = [MBCheck isValidEmail:textField.text];

}

@end
