//
//  RadarsImportManager.m
//  TrackMyRadars
//
//  Created by Maria Bernis on 04/12/14.
//  Copyright (c) 2014 mariabernis. All rights reserved.
//

#import "RadarsImportManager.h"
#import "RedboothAPIClient.h"
#import "OpenradarAPIClient.h"
#import "RadarTask.h"

@interface RadarsImportManager ()
@property (nonatomic, strong) NSString *opEmail;
@property (nonatomic, assign) NSInteger organizationId;
@end


@implementation RadarsImportManager

- (instancetype)initWithOpEmail:(NSString *)opEmail andOrganizationId:(NSInteger)organizationId
{
    self = [super init];
    if (self) {
        _opEmail = opEmail;
        _organizationId = organizationId;
    }
    return self;
}

- (void)importRadarsWithTemporaryContent:(void(^)(NSArray *tempRadars))tempContent
                                progress:(void(^)(NSUInteger index, RadarTask *importedRadar))progress
                              completion:(void(^)(NSArray *importedRadars, NSError *error))completion {
    
    
}

- (void)postTasksForOpenradars:(NSArray *)radars
                     inProject:(NSInteger)projectId
                    inTaskList:(NSInteger)taskListId
                      progress:(void(^)(NSUInteger index, RadarTask *importedRadar))progress
                    completion:(void(^)(NSArray *importedRadars, NSError *error))completion {
    
    RedboothAPIClient *redboothClient = [RedboothAPIClient sharedInstance];
    
//    NSInteger total = radars.count;
//    __block NSInteger finished = 0;
    [radars enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        RadarTask *radar = (RadarTask *)obj;
        NSDictionary *taskParams = @{ @"project_id":@(projectId),
                                      @"task_list_id":@(taskListId),
                                      @"name":radar.radarTitle,
                                      @"description":radar.radarDescription,
                                      @"is_private":@(false)
                                      };
        
        [redboothClient POST:RB_PATH_TASK
                  parameters:taskParams
                     success:^(NSURLSessionDataTask *task, id responseObject) {
                         NSDictionary *taskInfo = [(NSArray *)responseObject firstObject];
                         radar.taskId = [[taskInfo objectForKey:@"id"] integerValue];
                         if (progress) {
                             progress(idx, radar);
                         }
                         
                     }
                     failure:^(NSURLSessionDataTask *task, NSError *error) {
                         NSLog(@"Error importing radar #%@: %@", radar.radarNumber, error);
                     }];
        
    }];
    
}

- (void)newRadarsProjectWithCompletion:(void(^)(NSInteger projectId, NSInteger taskListId, NSError *error))completion {
    
    RedboothAPIClient *redboothClient = [RedboothAPIClient sharedInstance];
    NSDictionary *projectParams = @{ @"name"           :@"Open radars",
                                     @"organization_id":@(self.organizationId),
                                     @"publish_pages"  :@(false)
                                     };
    [redboothClient POST:RB_PATH_PROJECT
              parameters:projectParams
                 success:^(NSURLSessionDataTask *task, id responseObject) {
                     
                     NSDictionary *projInfo = [(NSArray *)responseObject firstObject];
                     NSInteger projId = [[projInfo objectForKey:@"id"] integerValue];
                     
                     [redboothClient GET:RB_PATH_TASKLIST
                              parameters:@{ @"project_id":@(projId) }
                                 success:^(NSURLSessionDataTask *task, id responseObject) {
                                     
                                     NSDictionary *taskListInfo = [(NSArray *)responseObject firstObject];
                                     NSInteger taskListId = [[taskListInfo objectForKey:@"id"] integerValue];
                                     
                                     completion(projId, taskListId, nil);
                                 }
                                 failure:^(NSURLSessionDataTask *task, NSError *error) {
                                     completion(0, 0, error);
                                 }];
                     
                 }
                 failure:^(NSURLSessionDataTask *task, NSError *error) {
                     completion(0, 0, error);
                 }];
}


- (void)fetchOpenradarsWithCompletion:(void(^)(NSArray *radars, NSError *error))completion {
    NSAssert(completion != nil, @"Completion block is needed");
    
    OpenradarAPIClient *openradarClient = [OpenradarAPIClient sharedInstance];
    [openradarClient GET:OP_PATH_RADAR
              parameters:@{ @"user":self.opEmail }
                 success:^(NSURLSessionDataTask *task, id responseObject) {
                     NSArray *results = [responseObject objectForKey:@"result"];
                     NSArray *parsedRadars = [self parseOpenradarsJson:results];
                     completion(parsedRadars, nil);
                 }
                 failure:^(NSURLSessionDataTask *task, NSError *error) {
                     NSLog(@"😱 Radars Error: %@", error);
                     completion(nil, error);
                 }];
}

- (NSArray *)parseOpenradarsJson:(NSArray *)jsonArray {
    
    NSMutableArray *parsedArray = [[NSMutableArray alloc] init];
//    [jsonArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//        NSDictionary *itemInfo = (NSDictionary *)obj;
//        RadarTask *radarTask = [[RadarTask alloc] initWithOPAPIInfo:itemInfo];
//        [parsedArray addObject:radarTask];
//    }];

    return parsedArray;
}

@end
