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
#import <PQFCustomLoaders/PQFCustomLoaders.h>
#import "RadarsImportManager.h"
#import "RadarTaskCell.h"
#import "RadarTask.h"
#import "RadarsProject.h"
#import "RadarTasksProvider.h"
#import "UIColor+TrackMyRadars.h"
#import "UIButton+TrackMyRadars.h"
#import "MBTagLabel.h"

@interface RadarListViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *radars;
@property (nonatomic, strong) RadarsProject *importedProject;
@property (nonatomic, strong) RadarTasksProvider *tasksProvider;
@property (nonatomic, strong) RadarsImportManager *importManager;
@property (nonatomic, strong) PQFCirclesInTriangle *loader;

// Outlets
@property (weak, nonatomic) IBOutlet UITableView *radarsTableView;
@property (weak, nonatomic) IBOutlet UIView *noImportView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *importBarButton;

@end


@implementation RadarListViewController

- (NSMutableArray *)radars
{
    if (!_radars) {
        _radars = [[NSMutableArray alloc] init];
    }
    return _radars;
}

- (RadarsProject *)importedProject
{
    if (!_importedProject) {
        _importedProject = [RadarsProject importedProject];
    }
    return _importedProject;
}

- (RadarTasksProvider *)tasksProvider
{
    if (!_tasksProvider) {
        _tasksProvider = [[RadarTasksProvider alloc] init];
    }
    return _tasksProvider;
}

- (PQFCirclesInTriangle *)loader
{
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
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor tmrLighterGrayColor];
    self.radarsTableView.dataSource = self;
    self.radarsTableView.delegate = self;
    self.radarsTableView.estimatedRowHeight = 80.0;
    self.radarsTableView.rowHeight = UITableViewAutomaticDimension;
    
    for (UIView *v in self.noImportView.subviews) {
        if ([v isKindOfClass:[UIButton class]]) {
            UIButton *b = (UIButton *)v;
            [b tmrStyle];
        }
    }
    
    if (self.importedProject) {
        [self showImportedData];
        [self loadRadarsFromRBProject:self.importedProject];
        // Add pull to refresh
    } else {
        [self showNoImportView];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Actions
- (void)loadRadarsFromRBProject:(RadarsProject *)project
{
    self.loader.label.text = @"Loading radar tasks";
    self.importBarButton.enabled = NO;
    [self.loader show];
    [self.tasksProvider fetchRBRadarsWithProject:project
                                      completion:^(NSArray *radars, NSError *error) {
                                          
                                          [self.radars removeAllObjects];
                                          [self.radars addObjectsFromArray:radars];
                                          [self.radarsTableView reloadData];
                                          
                                          self.importBarButton.enabled = YES;
                                          [self.loader hide];
                                      }];
}

- (IBAction)startImport:(id)sender
{
    UINavigationController *navVC = [self.storyboard instantiateViewControllerWithIdentifier:@"WizardOneNav"];
    WizardOpEmailViewController *wizardEmailVC = (WizardOpEmailViewController *)[navVC topViewController];
    wizardEmailVC.delegate = self;
    [self presentViewController:navVC animated:YES completion:nil];
}

- (void)showNoImportView
{
    self.navigationItem.title = @"Track My Radars";
    self.noImportView.hidden = NO;
    self.radarsTableView.hidden = YES;
}

- (void)showImportedData
{
    self.navigationItem.title = self.importedProject.radarsProjectName;
    self.noImportView.hidden = YES;
    self.radarsTableView.hidden = NO;
}

- (void)hideLoader
{
    [self.loader hide];
}

#pragma mark - WizardDelegate
- (void)wizardDidFinishWithOpEmail:(NSString *)email
                       projectName:(NSString *)name
                    organizationId:(NSInteger)organizationId
{
    [self showImportedData];
    self.navigationItem.title = name;
    self.importBarButton.enabled = NO;
    self.radarsTableView.userInteractionEnabled = NO;
    self.loader.label.text = @"Getting Openradars";
    [self.loader show];
    self.importManager = [[RadarsImportManager alloc] initWithOpEmail:email projectName:name andOrganizationId:organizationId];
    [self.importManager
     importRadarsWithTemporaryContent:^(NSArray *tempRadars) {
         
         [self.radars removeAllObjects];
         [self.radars addObjectsFromArray:tempRadars];
         [self.radarsTableView reloadData];
         self.loader.label.text = @"Importing to Redbooth";
     }
     progress:^(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations) {
         
         self.loader.label.text = [NSString stringWithFormat:@"%lu of %lu imported", (unsigned long)numberOfFinishedOperations, (unsigned long)totalNumberOfOperations];
     }
     import:^(NSUInteger index, RadarTask *importedRadar, NSError *error) {
         
         if (!error) {
             [self.radars replaceObjectAtIndex:index withObject:importedRadar];
             [self updateCellAtRow:index];
         }
     }
     completion:^(NSArray *importedRadars, NSError *error) {
         
         [self.radars removeAllObjects];
         [self.radars addObjectsFromArray:importedRadars];
         [self.radarsTableView reloadData];
         
         self.importBarButton.enabled = YES;
         self.radarsTableView.userInteractionEnabled = YES;
         self.loader.label.text = @"Import completed!";
         [self performSelector:@selector(hideLoader) withObject:nil afterDelay:0.5];
     }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.radars.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RadarTaskCell *cell = (RadarTaskCell *)[tableView dequeueReusableCellWithIdentifier:@"RadarTaskCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self configureCell:cell forIndexPath:indexPath];

    return cell;
}

#pragma mark datasuorce Helpers
- (void)configureCell:(RadarTaskCell *)cell forIndexPath:(NSIndexPath *)indexPath
{
    RadarTask *radar = self.radars[indexPath.row];
    cell.radarTitleLabel.text = radar.radarTitle;
    cell.numberLabel.text = [NSString stringWithFormat:@"#%@", radar.radarNumber];
    cell.statusLabel.text = radar.radarStatus;
    cell.imported = radar.isImported;
    if (radar.isImported) {
        if ([radar.radarStatus isEqualToString:kRadarStatusOpen]) {
            cell.statusLabel.backgroundColor = [UIColor tmrMainColor];
        } else {
            cell.statusLabel.backgroundColor = [UIColor tmrDisabledColor];
        }
    }
}

- (void)updateCellAtRow:(NSUInteger)row
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    
    [self.radarsTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    UITableViewRowAnimation rowAnimation;
    if(row != 0 && ((int)row % 5) == 0){
        NSLog(@"🐼 scroll tableview");
        rowAnimation = UITableViewRowAnimationNone;
        [self.radarsTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    } else {
        rowAnimation = UITableViewRowAnimationLeft;
    }    
}

@end
