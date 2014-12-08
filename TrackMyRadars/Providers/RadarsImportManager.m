//
//  RadarsImportManager.m
//  TrackMyRadars
//
//  Created by Maria Bernis on 04/12/14.
//  Copyright (c) 2014 mariabernis. All rights reserved.
//

#import "RadarsImportManager.h"
#import "RadarsProjectProvider.h"
#import "RadarTasksProvider.h"
#import "RadarsProject.h"

@interface RadarsImportManager ()
@property (nonatomic, strong) NSString *opEmail;
@property (nonatomic, strong) NSString *projectName;
@property (nonatomic, assign) NSInteger organizationId;
@property (nonatomic, strong) RadarsProjectProvider *projectsProvider;
@property (nonatomic, strong) RadarTasksProvider *tasksProvider;
@end


@implementation RadarsImportManager

/* Designated initializer */
- (instancetype)initWithOpEmail:(NSString *)opEmail projectName:(NSString *)name andOrganizationId:(NSInteger)organizationId
{
    self = [super init];
    if (self) {
        _opEmail = opEmail;
        _projectName = name;
        _organizationId = organizationId;
    }
    return self;
}

- (RadarsProjectProvider *)projectsProvider {
    if (!_projectsProvider) {
        _projectsProvider = [[RadarsProjectProvider alloc] initWithOpUser:self.opEmail projectName:self.projectName];
    }
    return _projectsProvider;
}

- (RadarTasksProvider *)tasksProvider {
    if (!_tasksProvider) {
        _tasksProvider = [[RadarTasksProvider alloc] init];
    }
    return _tasksProvider;
}

- (void)importRadarsWithTemporaryContent:(void(^)(NSArray *tempRadars))tempContent
                                progress:(void(^)(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations))progressBlock
                                  import:(void(^)(NSUInteger index, RadarTask *importedRadar, NSError *error))importBlock
                              completion:(void(^)(NSArray *importedRadars, NSError *error))completionBlock {
    
    [self.tasksProvider fetchOpenradarsWithOPUser:self.opEmail
                                       completion:^(NSArray *radars, NSError *error) {
        if (error) {
            if (completionBlock) {
                completionBlock(nil, error);
            }
            return;
        }
                                           
        if (tempContent) {
            tempContent(radars);
        }
        
        [self.projectsProvider newRadarsProjectWithName:self.projectName
                                       organizationId:self.organizationId
                                       completion:^(RadarsProject *project, NSError *error) {

            if (error) {
                if (completionBlock) {
                    completionBlock(nil, error);
                }
                return;
            }
            
            [self.tasksProvider postTasksForOpenradars:radars
                                             inProject:project
                                              progress:progressBlock
                                                import:importBlock
                                            completion:^(NSArray *importedRadars) {
                                                if (completionBlock) {
                                                    completionBlock(importedRadars, nil);
                                                }
                                            }];
        }];
    }];
    
}

@end
