//
//  OrganizationParser.m
//  TrackMyRadars
//
//  Created by Maria Bernis on 04/12/14.
//  Copyright (c) 2014 mariabernis. All rights reserved.
//

#import "OrganizationParser.h"
#import "Organization.h"

@implementation OrganizationParser

+ (NSArray *)organizationsWithJSONArray:(NSArray *)array atLeastOneRemainingProject:(BOOL)atLeastOne {
    
    NSMutableArray *items = [[NSMutableArray alloc] init];
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Organization *item = [self organizationWithJSONInfo:(NSDictionary *)obj];
        if (atLeastOne) {
            if (item.remainingProjects) {
                [items addObject:item];
            }
        } else {
            [items addObject:item];
        }
        
    }];
    
    return [NSArray arrayWithArray:items];
}

+ (Organization *)organizationWithJSONInfo:(NSDictionary *)info {
    
    Organization *item = [[Organization alloc] init];
    item.oragnizationId = [[info objectForKey:@"id"] integerValue];
    item.organizationName = [info objectForKey:@"name"];
    item.remainingProjects = [[info objectForKey:@"remaining_projects"] integerValue];
    return item;
}

@end
