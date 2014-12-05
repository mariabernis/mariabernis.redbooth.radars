//
//  RadarTaskParser.h
//  TrackMyRadars
//
//  Created by Maria Bernis on 04/12/14.
//  Copyright (c) 2014 mariabernis. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RadarTask;
@interface RadarTaskParser : NSObject

+ (NSArray *)radarTasksWithJSONArray:(NSArray *)array;
+ (RadarTask *)radarTaskWithJSONInfo:(NSDictionary *)info;

@end
