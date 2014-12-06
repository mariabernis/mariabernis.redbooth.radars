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
#import "RadarsImportManager.h"
#import "RadarTask.h"
#import "RadarsProject.h"
#import "RadarTasksProvider.h"
#import <PQFCustomLoaders/PQFCustomLoaders.h>

@interface RadarListViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *radars;
@property (nonatomic, strong) RadarsProject *importedProject;
@property (nonatomic, strong) RadarTasksProvider *tasksProvider;
@property (nonatomic, strong) RadarsImportManager *importManager;
@property (nonatomic, strong) PQFCirclesInTriangle *loader;

// Outlets
@property (weak, nonatomic) IBOutlet UITableView *radarsTableView;
@property (weak, nonatomic) IBOutlet UIView *noImportView;
@end


@implementation RadarListViewController

- (NSMutableArray *)radars {
    
    if (!_radars) {
        _radars = [[NSMutableArray alloc] init];
    }
    return _radars;
}

- (RadarsProject *)importedProject {
    
    if (!_importedProject) {
        _importedProject = [RadarsProject importedProject];
    }
    return _importedProject;
}

- (RadarTasksProvider *)tasksProvider {
    
    if (!_tasksProvider) {
        _tasksProvider = [[RadarTasksProvider alloc] init];
    }
    return _tasksProvider;
}

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
    self.view.backgroundColor = [UIColor flatCloudsColor];
    self.radarsTableView.dataSource = self;
    self.radarsTableView.delegate = self;
    
    if (self.importedProject) {
        [self showImportedData];
        [self loadRadarsFromRBProject:self.importedProject];
        // Add pull to refresh
    } else {
        [self showNoImportView];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Actions
- (void)showNoImportView {
    self.noImportView.hidden = NO;
    self.radarsTableView.hidden = YES;
}

- (void)showImportedData {
    self.noImportView.hidden = YES;
    self.radarsTableView.hidden = NO;
    // pull to refresh
}

- (void)loadRadarsFromRBProject:(RadarsProject *)project {
    
    [self.tasksProvider fetchRBRadarsWithProject:project
                                      completion:^(NSArray *radars, NSError *error) {
                                          
                                          [self.radars removeAllObjects];
                                          [self.radars addObjectsFromArray:radars];
                                          [self.radarsTableView reloadData];
                                      }];
}

- (IBAction)startImport:(id)sender {
    UINavigationController *navVC = [self.storyboard instantiateViewControllerWithIdentifier:@"WizardOneNav"];
    WizardOpEmailViewController *wizardEmailVC = (WizardOpEmailViewController *)[navVC topViewController];
    wizardEmailVC.delegate = self;
    [self presentViewController:navVC animated:YES completion:nil];
}

#pragma mark - WizardDelegate
- (void)wizardDidFinishWithOpEmail:(NSString *)email
                    organizationId:(NSInteger)organizationId {
    
    [self showImportedData];
    [self.loader show];
    self.importManager = [[RadarsImportManager alloc] initWithOpEmail:email andOrganizationId:organizationId];
    [self.importManager importRadarsWithTemporaryContent:^(NSArray *tempRadars) {
        
                                                    [self.radars removeAllObjects];
                                                    [self.radars addObjectsFromArray:tempRadars];
                                                    [self.radarsTableView reloadData];
                                                }
                                                progress:^(NSUInteger index, RadarTask *importedRadar) {
                                                    
                                                    [self.radars replaceObjectAtIndex:index withObject:importedRadar];
                                                    [self updateCellAtRow:index];
                                                }
                                              completion:^(NSArray *importedRadars, NSError *error) {
                                                  
                                                  [self.radars removeAllObjects];
                                                  [self.radars addObjectsFromArray:importedRadars];
                                                  [self.radarsTableView reloadData];
                                                  [self.loader hide];
                                              }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.radars.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RadarTask *radar = self.radars[indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RadarCell" forIndexPath:indexPath];
    
    if (radar.isImported) {
        // Rb task
        [self configureRBRadarCell:cell withRadar:radar];
    } else {
        // It's not yet imported to RB
        [self configureOPRadarCell:cell withRadar:radar];
    }
    return cell;
}

#pragma datasuorce Helpers
- (void)configureRBRadarCell:(UITableViewCell *)cell withRadar:(RadarTask *)radar{
    
    cell.textLabel.text = radar.radarTitle;
    
    cell.textLabel.font = [UIFont boldSystemFontOfSize:17.0];
    cell.textLabel.textColor = [UIColor flatWetAsphaltColor];
}

- (void)configureOPRadarCell:(UITableViewCell *)cell withRadar:(RadarTask *)radar{
    
    cell.textLabel.text = radar.radarTitle;
    
    cell.textLabel.font = [UIFont boldSystemFontOfSize:17.0];
    cell.textLabel.textColor = [UIColor flatAsbestosColor];
}

- (void)updateCellAtRow:(NSUInteger)row {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    [self.radarsTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    
//    if (self.selectedIndex) {
//        UITableViewCell *prevCell = [tableView cellForRowAtIndexPath:self.selectedIndex];
//        prevCell.accessoryType = UITableViewCellAccessoryNone;
//    }
//    
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    cell.accessoryType = UITableViewCellAccessoryCheckmark;
//    
//    self.selectedIndex = indexPath;
}


@end
