//
//  OrganizationsProvider.m
//  TrackMyRadars
//
//  Created by Maria Bernis on 04/12/14.
//  Copyright (c) 2014 mariabernis. All rights reserved.
//

#import "OrganizationsProvider.h"
#import "RedboothAPIClient.h"
#import "OrganizationParser.h"


@implementation OrganizationsProvider

- (void)fetchOrganizationsWithRemainingProjects:(void(^)(NSArray *organizations, NSError * error))completion
{
    RedboothAPIClient *redboothClient = [RedboothAPIClient sharedInstance];
    [redboothClient GET:RB_PATH_ORGANIZATION
             parameters:nil
                success:^(NSURLSessionDataTask *task, id responseObject) {
                    
                    NSArray *organizations = [OrganizationParser organizationsWithJSONArray:(NSArray *)responseObject
                                                                 atLeastOneRemainingProject:YES];
                    if (completion) {
                        completion(organizations, nil);
                    }
        
                }
                failure:^(NSURLSessionDataTask *task, NSError *error) {
                    NSLog(@"😱 Error loading Organizations: %@", error);
                    if (completion) {
                        completion(nil, error);
                    }
                }];
}

@end
