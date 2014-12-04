//
//  WizardRbOrganizationViewController.m
//  TrackMyRadars
//
//  Created by Maria Bernis on 04/12/14.
//  Copyright (c) 2014 mariabernis. All rights reserved.
//

#import "WizardRbOrganizationViewController.h"
#import "Organization.h"
#import "RedboothAPIClient.h"

#define RB_PATH_ORGANIZATION @"api/3/organizations"

@interface WizardRbOrganizationViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSArray *organizations; // Of Organization
@property (nonatomic, strong) NSIndexPath *selectedIndex;

// Outlets
@property (weak, nonatomic) IBOutlet UITableView *organizationsTableView;
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
- (IBAction)startRadarsImport:(id)sender {
    
}

- (void)loadOrganizationList {
    RedboothAPIClient *redboothClient = [RedboothAPIClient sharedInstance];
    [redboothClient GET:RB_PATH_ORGANIZATION parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *results = (NSArray *)responseObject;
        NSMutableArray *parsedResults = [[NSMutableArray alloc] init];
        for (NSDictionary *item in results) {
            // Show only organizations with capacity for new projects
            Organization *organization = [[Organization alloc] initWithAPIInfo:item];
            if (organization.remainingProjects) {
                [parsedResults addObject:organization];
            }
            
        }
        self.organizations = parsedResults;
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"😱 Error: %@", error);
    }];
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
    
    if (self.selectedIndex == indexPath) {
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
