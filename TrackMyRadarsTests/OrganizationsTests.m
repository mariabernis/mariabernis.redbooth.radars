//
//  OrganizationsTests.m
//  TrackMyRadars
//
//  Created by Maria Bernis on 05/12/14.
//  Copyright (c) 2014 mariabernis. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "Organization.h"
#import "OrganizationParser.h"

SPEC_BEGIN(OrganizationsParsing)

describe(@"When receiving array of Redbooth Organizations", ^{
    
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"organizations_stub" ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:path];
    NSError *error = nil;
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    
    context(@"Parsing the whole array to objects", ^{
        
        NSArray *allOrganizations = [OrganizationParser organizationsWithJSONArray:jsonArray atLeastOneRemainingProject:NO];
        it(@"Should return an array of 3 Organization objects", ^{
            
            [[theValue(allOrganizations.count) should] equal:@3];
        });
        
        it(@"Should have the 'Freelander', 'Personal' and 'flash2flash' organizations", ^{
            [[((Organization *)allOrganizations[0]).organizationName should] equal:@"Freelander"];
            [[((Organization *)allOrganizations[1]).organizationName should] equal:@"Personal"];
            [[((Organization *)allOrganizations[2]).organizationName should] equal:@"flash2flash"];
            
        });
    });
    
    context(@"Getting the organizations that still can have more projects", ^{
        
        NSArray *usefulOrganizations = [OrganizationParser organizationsWithJSONArray:jsonArray atLeastOneRemainingProject:YES];
        it(@"Should return an array of 1 Organization object", ^{
            
            [[theValue(usefulOrganizations.count) should] equal:@1];
        });
        
        it(@"Should have the 'flash2flash' organization", ^{
            [[((Organization *)usefulOrganizations[0]).organizationName should] equal:@"flash2flash"];
            
        });
    });
    
});

SPEC_END