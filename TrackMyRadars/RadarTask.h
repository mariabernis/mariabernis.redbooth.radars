//
//  RadarTask.h
//  TrackMyRadars
//
//  Created by Maria Bernis on 04/12/14.
//  Copyright (c) 2014 mariabernis. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const kRadarStatusOpen;
extern NSString * const kRadarStatusResolved;

@interface RadarTask : NSObject
@property (nonatomic, assign) NSInteger taskId;
@property (nonatomic, strong) NSString *radarNumber;
@property (nonatomic, strong) NSString *radarTitle;
@property (nonatomic, strong) NSString *radarDescription;
@property (nonatomic, strong) NSString *radarStatus;
@property (nonatomic, assign, getter=isImported, readonly) BOOL imported;

@end
