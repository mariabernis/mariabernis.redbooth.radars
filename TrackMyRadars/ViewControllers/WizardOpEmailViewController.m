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
#import "WizardStepsView.h"
#import "UIColor+TrackMyRadars.h"
#import "UIButton+TrackMyRadars.h"
#import "UIView+TrackMyRadars.h"

@interface WizardOpEmailViewController ()<UITextFieldDelegate>

// Outlets
@property (weak, nonatomic) IBOutlet UILabel *opEmailLabel;
@property (weak, nonatomic) IBOutlet UITextField *opEmailField;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UIView *fieldWrapper;

@end

@implementation WizardOpEmailViewController

#pragma mark - VC life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.opEmailField.delegate = self;
    self.nextButton.enabled = NO;
    
    self.view.backgroundColor = [UIColor tmrLighterGrayColor];
    self.opEmailLabel.textColor = [UIColor tmrMainColor];
    [self.fieldWrapper tmrFieldBckStyle];
    [self.nextButton tmrStyle];
    
    CGRect frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 60);
    WizardStepsView *stepsView = [[WizardStepsView alloc] initWithFrame:frame step:1];
    [self.view addSubview:stepsView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationItem.title = @"Import radars";
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.navigationItem.title = @"";
}

#pragma mark - Actions
- (IBAction)dismissKeyboardIfShowing:(UITapGestureRecognizer *)sender
{
    if ([self.opEmailField isFirstResponder]) {
        [self.opEmailField resignFirstResponder];
    }
}

- (IBAction)dismissWizard:(id)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"WizardTwoSegue"]) {
        WizardRbOrganizationViewController *wizardTwoVC = segue.destinationViewController;
        wizardTwoVC.delegate = self.delegate;
        wizardTwoVC.opEmail = self.opEmailField.text;
    }
}


#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    BOOL isValidEmail = [MBCheck isValidEmail:self.opEmailField.text];
    if (!isValidEmail) {
        self.fieldWrapper.backgroundColor = [UIColor colorWithHue:0.583 saturation:0.551 brightness:0.568 alpha:0.4];
        self.opEmailField.placeholder = @"Enter a valid email";
    } else {
        self.fieldWrapper.backgroundColor = [UIColor tmrWhiteColor];
        self.opEmailField.placeholder = @"email";
    }
    self.nextButton.enabled = [MBCheck isValidEmail:self.opEmailField.text];
}

@end
