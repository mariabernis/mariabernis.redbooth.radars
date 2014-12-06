//
//  RadarTaskParser.m
//  TrackMyRadars
//
//  Created by Maria Bernis on 04/12/14.
//  Copyright (c) 2014 mariabernis. All rights reserved.
//

#import "RadarTaskParser.h"
#import "RadarTask.h"
#import "RadarsProject.h"

@implementation RadarTaskParser

#pragma mark - Openradar fetch
+ (NSArray *)radarTasksWithOPArray:(NSArray *)array {
    NSMutableArray *items = [[NSMutableArray alloc] init];
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        RadarTask *item = [self radarTaskWithOPInfo:(NSDictionary *)obj];
        [items addObject:item];
    }];
    
    return [NSArray arrayWithArray:items];
}

+ (RadarTask *)radarTaskWithOPInfo:(NSDictionary *)info {
    
    RadarTask *item = [[RadarTask alloc] init];
    item.radarNumber = [info objectForKey:@"number"];
    item.radarTitle = [info objectForKey:@"title"];
    item.radarDescription = [info objectForKey:@"description"];
    NSString *opStatus = [info objectForKey:@"status"];
    item.radarStatus = [self simplifiedStatusForOPStatus:opStatus];
    
    return item;
}

+ (NSString *)simplifiedStatusForOPStatus:(NSString *)opStatus {
    
    NSString *status = nil;
    NSString *lowOpStatus = [opStatus lowercaseString];
    if ([lowOpStatus containsString:@"closed"] ||
        [lowOpStatus containsString:@"resolved"]) {
        status = kRadarStatusResolved;
    } else {
        status = kRadarStatusOpen;
    }
    return status;
}

#pragma mark - Redbooth fetch
+ (NSArray *)radarTasksWithRBArray:(NSArray *)array {
    NSMutableArray *items = [[NSMutableArray alloc] init];
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        RadarTask *item = [self radarTaskWithRBInfo:(NSDictionary *)obj];
        [items addObject:item];
    }];
    
    return [NSArray arrayWithArray:items];
}

+ (RadarTask *)radarTaskWithRBInfo:(NSDictionary *)info {
    
    RadarTask *item = [[RadarTask alloc] init];
    //    item.radarNumber = [info objectForKey:@"number"];
    item.taskId = [[info objectForKey:@"id"] integerValue];
    item.radarTitle = [info objectForKey:@"name"];
    item.radarDescription = [info objectForKey:@"description"];
    item.radarStatus = [info objectForKey:@"status"];
    
    return item;
}

+ (NSDictionary *)rbGetTasksParametersWithProject:(RadarsProject *)project {
    
    NSDictionary *taskParams = @{ @"project_id"  :@(project.radarsProjectId),
                                  @"task_list_id":@(project.radarsTaskListId)
                                  };
    return taskParams;
}

#pragma mark - Redbooth post
+ (NSDictionary *)rbPostTaskParametersWithRadarTask:(RadarTask *)radar andRadarProject:(RadarsProject *)project {
    
    NSDictionary *taskParams = @{ @"project_id"  :@(project.radarsProjectId),
                                  @"task_list_id":@(project.radarsTaskListId),
                                  @"name"        :radar.radarTitle,
                                  @"description" :radar.radarDescription,
                                  @"is_private"  :@"false"
                                  };
    return taskParams;
}



@end
