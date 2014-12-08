//
//  WizardRbOrganizationViewController.m
//  TrackMyRadars
//
//  Created by Maria Bernis on 04/12/14.
//  Copyright (c) 2014 mariabernis. All rights reserved.
//

#import "WizardRbOrganizationViewController.h"
#import "Organization.h"
#import "OrganizationsProvider.h"
#import "RadarTasksProvider.h"
#import "RadarsProjectProvider.h"
#import "MBCheck.h"
#import "WizardStepsView.h"
#import "UIColor+TrackMyRadars.h"
#import "UIButton+TrackMyRadars.h"
#import "UIView+TrackMyRadars.h"
#import <PQFCustomLoaders/PQFCustomLoaders.h>

@interface WizardRbOrganizationViewController ()<UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSArray *organizations; // Of Organization
@property (nonatomic, strong) NSIndexPath *selectedIndex;
@property (nonatomic, strong) OrganizationsProvider *organizationsProvider;
@property (nonatomic, strong) PQFCirclesInTriangle *loader;

// Outlets
@property (weak, nonatomic) IBOutlet UITableView *organizationsTableView;
@property (weak, nonatomic) IBOutlet UIButton *importButton;
@property (weak, nonatomic) IBOutlet UIView *fieldWrapper;
@property (weak, nonatomic) IBOutlet UILabel *projNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *projNameField;
@property (weak, nonatomic) IBOutlet UILabel *organizationsLabel;
@property (weak, nonatomic) IBOutlet UIView *loaderPlaceholder;
@end


@implementation WizardRbOrganizationViewController

@synthesize organizations = _organizations;

- (NSArray *)organizations {
    if (!_organizations) {
        _organizations = [[NSArray alloc] init];
    }
    return _organizations;
}

- (void)setOrganizations:(NSArray *)organizations {
    _organizations = [NSArray arrayWithArray:organizations];
    [self.organizationsTableView reloadData];
}

- (OrganizationsProvider *)organizationsProvider {
    if (!_organizationsProvider) {
        _organizationsProvider = [[OrganizationsProvider alloc] init];
    }
    return _organizationsProvider;
}

- (PQFCirclesInTriangle *)loader {
    if (!_loader) {
        _loader = [[PQFCirclesInTriangle alloc] initLoaderOnView:self.view];
        _loader.loaderColor = [UIColor tmrMainColor];
        // Manually set center
        _loader.center = CGPointMake(self.view.center.x, self.organizationsTableView.center.y - 64.0);
    }
    return _loader;
}

#pragma mark - VC life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Import radars";
    
    self.projNameField.delegate = self;
    self.organizationsTableView.dataSource = self;
    self.organizationsTableView.delegate = self;
    
    self.view.backgroundColor = [UIColor tmrLighterGrayColor];
    self.loaderPlaceholder.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.95];
    self.loaderPlaceholder.hidden = YES;
    self.projNameLabel.textColor = [UIColor tmrMainColor];
    self.organizationsLabel.textColor = [UIColor tmrMainColor];
    [self.importButton tmrStyle];
    [self.fieldWrapper tmrFieldBckStyle];
    
    CGRect frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 60);
    WizardStepsView *stepsView = [[WizardStepsView alloc] initWithFrame:frame step:2];
    [self.view addSubview:stepsView];
    
    [self loadOrganizationList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark - Actions
- (void)loadOrganizationList {
    
    self.importButton.enabled = NO;
    [self showLoader];
    [self.organizationsProvider fetchOrganizationsWithRemainingProjects:^(NSArray *organizations, NSError *error) {
        
        [self hideLoader];
        if (error) {
            return;
        }
        self.organizations = organizations;
        self.importButton.enabled = YES;
    }];
}

- (IBAction)dismissKeyboardIfShowing:(UITapGestureRecognizer *)sender {
    if ([self.projNameField isFirstResponder]) {
        [self.projNameField resignFirstResponder];
    }
}

- (IBAction)startRadarsImport:(id)sender {
    
    if (self.delegate) {
        Organization *selected = self.organizations[self.selectedIndex.row];
        [self.delegate wizardDidFinishWithOpEmail:self.opEmail projectName:self.projNameField.text organizationId:selected.oragnizationId];
    }
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)showLoader {
    self.loaderPlaceholder.hidden = NO;
    [self.loader show];
}

- (void)hideLoader {
    self.loaderPlaceholder.hidden = YES;
    [self.loader hide];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    BOOL isEmptyText = [MBCheck isEmpty:self.projNameField.text];
    if (isEmptyText) {
        self.fieldWrapper.backgroundColor = [UIColor colorWithHue:0.583 saturation:0.551 brightness:0.568 alpha:0.4];
        self.projNameField.placeholder = @"Name your project";
    } else {
        self.fieldWrapper.backgroundColor = [UIColor tmrWhiteColor];
        self.projNameField.placeholder = @"Ej: Track My Radars";
    }
    self.importButton.enabled = !isEmptyText;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.organizations.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    Organization *organization = self.organizations[indexPath.row];
    cell.textLabel.text = organization.organizationName;
    
    if (self.selectedIndex == nil && indexPath.row == 0) {
        self.selectedIndex = indexPath;
    }
    
    if (self.selectedIndex.row == indexPath.row) {
        cell.accessoryType =  UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.selectedIndex) {
        UITableViewCell *prevCell = [tableView cellForRowAtIndexPath:self.selectedIndex];
        prevCell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;

    self.selectedIndex = indexPath;
}

@end
