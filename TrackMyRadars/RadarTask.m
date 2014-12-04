//
//  RadarTask.m
//  TrackMyRadars
//
//  Created by Maria Bernis on 04/12/14.
//  Copyright (c) 2014 mariabernis. All rights reserved.
//

#import "RadarTask.h"


NSString * const kRadarStatusOpen = @"open";
NSString * const kRadarStatusResolved = @"resolved";

@implementation RadarTask

- (void)setTaskId:(NSInteger)taskId {
    _taskId = taskId;
    if (taskId) {
        _imported = YES;
    }
}



@end
