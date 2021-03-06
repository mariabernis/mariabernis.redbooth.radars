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

#pragma mark - Openradar 
#pragma fetch
+ (NSArray *)radarTasksWithOPArray:(NSArray *)array
{
    NSMutableArray *items = [[NSMutableArray alloc] init];
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        RadarTask *item = [self radarTaskWithOPInfo:(NSDictionary *)obj];
        [items addObject:item];
    }];
    
    return [NSArray arrayWithArray:items];
}

+ (RadarTask *)radarTaskWithOPInfo:(NSDictionary *)info
{
    RadarTask *item = [[RadarTask alloc] init];
    item.radarNumber = [info objectForKey:@"number"];
    item.radarTitle = [info objectForKey:@"title"];
    NSString *description = [info objectForKey:@"description"];
//    item.radarDescription = description;
    item.radarDescription = [self addRadarNumber:item.radarNumber toDescription:description];
    NSString *opStatus = [info objectForKey:@"status"];
    item.radarStatus = [self simplifiedStatusForOPStatus:opStatus];
    
    return item;
}

+ (NSString *)addRadarNumber:(NSString *)radarNumber toDescription:(NSString *)description
{
    return [NSString stringWithFormat:@"rdar://%@\r\n\r\n%@", radarNumber, description];
}

+ (NSString *)simplifiedStatusForOPStatus:(NSString *)opStatus
{
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

#pragma mark - Redbooth
#pragma mark fetch
+ (NSArray *)radarTasksWithRBArray:(NSArray *)array
{
    NSMutableArray *items = [[NSMutableArray alloc] init];
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        RadarTask *item = [self radarTaskWithRBInfo:(NSDictionary *)obj];
        [items addObject:item];
    }];
    
    return [NSArray arrayWithArray:items];
}

+ (RadarTask *)radarTaskWithRBInfo:(NSDictionary *)info
{
    RadarTask *item = [[RadarTask alloc] init];
    item.taskId = [[info objectForKey:@"id"] integerValue];
    item.radarTitle = [info objectForKey:@"name"];
    item.radarDescription = [info objectForKey:@"description"];
    item.radarStatus = [info objectForKey:@"status"];
    item.radarNumber = [self retrieveRadarNumberFromDescription:item.radarDescription];
    
    return item;
}

+ (NSString *)retrieveRadarNumberFromDescription:(NSString *)description
{
    NSString *matchString = @"rdar://";
    NSRange matchRadarNum = [description rangeOfString:matchString];
    if (matchRadarNum.length == NSNotFound) {
        return nil;
    }
    NSString *rdar = [description substringToIndex:matchRadarNum.length + 8];
    NSString *num = [rdar substringFromIndex:matchRadarNum.length];
    return num;
}

+ (NSDictionary *)rbGETTasksParametersWithProject:(RadarsProject *)project
{
    // Add per_page to max value, otherwise it will page at 30.
    NSDictionary *taskParams = @{ @"project_id"  :@(project.radarsProjectId),
                                  @"task_list_id":@(project.radarsTaskListId),
                                  @"per_page"    :@1000
                                  };
    return taskParams;
}

#pragma mark post
+ (NSDictionary *)rbPOSTTaskParametersWithRadarTask:(RadarTask *)radar andRadarProject:(RadarsProject *)project
{
    NSDictionary *taskParams = @{ @"project_id"  :@(project.radarsProjectId),
                                  @"task_list_id":@(project.radarsTaskListId),
                                  @"name"        :radar.radarTitle,
                                  @"description" :radar.radarDescription,
                                  @"status"      :radar.radarStatus,
                                  @"is_private"  :@"false"
                                  };
    return taskParams;
}



@end
