//
//  Organization.h
//  TrackMyRadars
//
//  Created by Maria Bernis on 04/12/14.
//  Copyright (c) 2014 mariabernis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Organization : NSObject

@property (nonatomic, assign) NSInteger oragnizationId;
@property (nonatomic, strong) NSString *organizationName;
@property (nonatomic, assign) NSInteger remainingProjects;

- (instancetype)initWithAPIInfo:(NSDictionary *)info;

@end
