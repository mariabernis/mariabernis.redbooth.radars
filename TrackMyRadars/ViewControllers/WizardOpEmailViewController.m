//
//  WizardOpEmailViewController.m
//  TrackMyRadars
//
//  Created by Maria Bernis on 04/12/14.
//  Copyright (c) 2014 mariabernis. All rights reserved.
//

#import "WizardOpEmailViewController.h"
#import "WizardRbOrganizationViewController.h"

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
- (BOOL)isValidEmail:(NSString*)email {
    BOOL result = NO;
    
    if (email.length > 0)
    {
        NSString *emailRegEx =
        @"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
        @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
        @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
        @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
        @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
        @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
        @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
        result = [emailTest evaluateWithObject:email];
        
    }
    return result;
}

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
    
    self.nextButton.enabled = [self isValidEmail:textField.text];

}

@end
