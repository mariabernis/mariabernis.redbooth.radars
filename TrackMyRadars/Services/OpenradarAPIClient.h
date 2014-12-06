//
//  OpenradarAPIClient.h
//  TrackMyRadars
//
//  Created by Maria Bernis on 04/12/14.
//  Copyright (c) 2014 mariabernis. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

#define OP_PATH_RADAR @"radar"

@interface OpenradarAPIClient : AFHTTPSessionManager

// Singleton instance
+ (instancetype)sharedInstance;

@end
