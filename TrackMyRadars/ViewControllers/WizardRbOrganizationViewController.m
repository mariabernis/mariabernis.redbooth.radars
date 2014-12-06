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

@interface WizardRbOrganizationViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSArray *organizations; // Of Organization
@property (nonatomic, strong) NSIndexPath *selectedIndex;
@property (nonatomic, strong) OrganizationsProvider *organizationsProvider;
@property (nonatomic, strong) RadarTasksProvider *radarsProvider;
@property (nonatomic, strong) RadarsProjectProvider *projectProvider;
@property (nonatomic, strong) NSArray *openRadars;

// Outlets
@property (weak, nonatomic) IBOutlet UITableView *organizationsTableView;
@property (weak, nonatomic) IBOutlet UIButton *importButton;
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

- (RadarTasksProvider *)radarsProvider {
    if (!_radarsProvider) {
        _radarsProvider = [[RadarTasksProvider alloc] init];
    }
    return _radarsProvider;
}

- (RadarsProjectProvider *)projectProvider {
    if (!_projectProvider) {
        _projectProvider = [[RadarsProjectProvider alloc] init];
    }
    return _projectProvider;
}


#pragma mark - VC life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Import radar";
    
    self.organizationsTableView.dataSource = self;
    self.organizationsTableView.delegate = self;
    
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
    [self.organizationsProvider fetchOrganizationsWithRemainingProjects:^(NSArray *organizations, NSError *error) {
        
        if (error) {
            return;
        }
        self.organizations = organizations;
        self.importButton.enabled = YES;
    }];
}

- (IBAction)startRadarsImport:(id)sender {
    
    if (self.delegate) {
        Organization *selected = self.organizations[self.selectedIndex.row];
        [self.delegate wizardDidFinishWithOpEmail:self.opEmail organizationId:selected.oragnizationId];
    }
    
//    [self.radarsProvider fetchOpenradarsWithOPUser:self.opEmail
//                                        completion:^(NSArray *radars, NSError *error) {
//                                            
//                                            if (error) {
//                                                return;
//                                            }
//                                            self.openRadars = [NSArray arrayWithArray:radars];
//                                            [self newProjectForRadars];
//                                        }];
    
}


/*
- (void)newProjectForRadars {
    
    Organization *selected = self.organizations[self.selectedIndex.row];
    [self.projectProvider newRadarsProjectWithOrganizationId:selected.oragnizationId
                                                  completion:^(NSInteger projectId, NSInteger taskListId, NSError *error) {
                                                      
                                                      if (error) {
                                                          return;
                                                      }
                                    
                                                      [self importRadarsIntoTasksAndFinalize:projectId taskList:taskListId];
                                                      
                                                  }];
}

- (void)importRadarsIntoTasksAndFinalize:(NSInteger)projectId taskList:(NSInteger)taskListId {
    [self.radarsProvider postTasksForOpenradars:self.openRadars
                                      inProject:projectId
                                     inTaskList:taskListId
                                       progress:^(NSUInteger index, RadarTask *importedRadar) {
                                           NSLog(@"🌠 Task imported at index %li", (unsigned long)index);
                                       }
                                     completion:^(NSArray *importedRadars, NSError *error) {
                                         NSLog(@"🐼 Importing ended with error: %@", error);
                                     }];
}
*/

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
