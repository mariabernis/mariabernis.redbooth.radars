//
//  Organization.m
//  TrackMyRadars
//
//  Created by Maria Bernis on 04/12/14.
//  Copyright (c) 2014 mariabernis. All rights reserved.
//

#import "Organization.h"


@implementation Organization

- (instancetype)initWithAPIInfo:(NSDictionary *)info
{
    self = [super init];
    if (self) {
        _oragnizationId = [[info objectForKey:@"id"] integerValue];
        _organizationName = [info objectForKey:@"name"];
        _remainingProjects = [[info objectForKey:@"remaining_projects"] integerValue];
    }
    return self;
}

@end
