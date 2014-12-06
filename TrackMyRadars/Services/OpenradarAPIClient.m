//
//  OpenradarAPIClient.m
//  TrackMyRadars
//
//  Created by Maria Bernis on 04/12/14.
//  Copyright (c) 2014 mariabernis. All rights reserved.
//

#import "OpenradarAPIClient.h"

#define OP_API_BASE_URL @"https://openradar.appspot.com/api"

@implementation OpenradarAPIClient

#pragma mark - Singleton instance
+ (instancetype)sharedInstance {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] initWithBaseURL:[NSURL URLWithString:OP_API_BASE_URL]];
    });
    return sharedInstance;
}

- (instancetype)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (self) {
        NSMutableSet *responseContentTypes = [NSMutableSet setWithSet:self.responseSerializer.acceptableContentTypes];
        [responseContentTypes addObject:@"text/html"];
        self.responseSerializer.acceptableContentTypes = [NSSet setWithSet:responseContentTypes];
    }
    return self;
}

#pragma mark - Authorisation
//- (void)setAuthorizationHeaderWithKey:(NSString *)apiKey {
//    [self.requestSerializer setValue:[NSString stringWithFormat:@"Basic %@", apiKey]
//                  forHTTPHeaderField:@"Authorization"];
//}

@end
