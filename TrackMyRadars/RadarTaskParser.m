//
//  RadarTaskParser.m
//  TrackMyRadars
//
//  Created by Maria Bernis on 04/12/14.
//  Copyright (c) 2014 mariabernis. All rights reserved.
//

#import "RadarTaskParser.h"
#import "RadarTask.h"

@implementation RadarTaskParser

+ (NSArray *)radarTasksWithJSONArray:(NSArray *)array {
    NSMutableArray *items = [[NSMutableArray alloc] init];
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        RadarTask *item = [self radarTaskWithJSONInfo:(NSDictionary *)obj];
        [items addObject:item];
    }];
    
    return [NSArray arrayWithArray:items];
}

+ (RadarTask *)radarTaskWithJSONInfo:(NSDictionary *)info {
    
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

@end
