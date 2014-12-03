//
//  RedboothAPIClient.m
//  TrackMyRadars
//
//  Created by Maria Bernis on 03/12/14.
//  Copyright (c) 2014 mariabernis. All rights reserved.
//

#import "RedboothAPIClient.h"
#import "GROAuth2SessionManager.h"

@implementation RedboothAPIClient

#pragma mark - Singleton instance
+ (instancetype)sharedInstance {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] initWithBaseURL:[NSURL URLWithString:API_BASE_URL]];
        NSString *savedToken = [[NSUserDefaults standardUserDefaults] stringForKey:KEY_ACCESS_TOKEN];
        if (savedToken) {
            [sharedInstance setAuthorizationHeaderWithToken:savedToken];
        }
    });
    return sharedInstance;
}

#pragma mark - Authentication
- (void)authorize {
    
    NSString *baseAuthURLStr = @"https://redbooth.com/oauth2/authorize";
    NSString *params = [NSString stringWithFormat:@"client_id=%@&redirect_uri=%@&response_type=code", API_CLIENT, API_CALLBACK_URL];
    NSString *scapedParams = [params stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    NSString *authURLStr = [NSString stringWithFormat:@"%@?%@", baseAuthURLStr, scapedParams];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:authURLStr]];
}


- (void)authorisedWithCallback:(NSString *)urlParams {
    
    NSArray *params = [urlParams componentsSeparatedByString:@"&"];
    
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
    [params enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSArray *keyValue = [(NSString *)obj componentsSeparatedByString:@"="];
        NSString *key = [keyValue[0] stringByRemovingPercentEncoding];
        NSString *value = [keyValue[1] stringByRemovingPercentEncoding];
        [paramsDict setObject:value forKey:key];
    }];
    
    NSLog(@"🐼 Auth info: %@", paramsDict);
    
    NSString *token = [paramsDict objectForKey:@"access_token"];
    if (token) {
        [self setAuthorizationHeaderWithToken:token];
        [self storeToken:token];
    } else {
        NSString *code = [paramsDict objectForKey:@"code"];
        [self authoriseWithCode:code];
    }
    
}

- (void)authoriseWithCode:(NSString *)code {
    
    GROAuth2SessionManager *sessionManager = [GROAuth2SessionManager managerWithBaseURL:[self baseURL]
                                                                               clientID:API_CLIENT
                                                                                 secret:API_SECRET];
    
    [sessionManager authenticateUsingOAuthWithPath:@"/oauth2/token"
                                              code:code
                                       redirectURI:API_CALLBACK_URL
                                           success:^(AFOAuthCredential *credential) {
                                               NSLog(@"Login successful");
                                               
                                               //Setting token singleton Redbooth API Client
                                               [self setAuthorizationHeaderWithToken:credential.accessToken];
                                               [self storeToken:credential.accessToken];
                                               
                                               // Enjoy!
                                               
                                           } failure:^(NSError *error) {
                                               NSLog(@"Error login: %@", error);
                                               
                                           }];
}

- (void)setAuthorizationHeaderWithToken:(NSString *)token {
    [self.requestSerializer setValue:[NSString stringWithFormat:@"OAuth %@", token]
                  forHTTPHeaderField:@"Authorization"];
}

- (void)storeToken:(NSString *)token {
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:KEY_ACCESS_TOKEN];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)hasStoredToken {
    BOOL result = NO;
    NSString *savedToken = [[NSUserDefaults standardUserDefaults] stringForKey:KEY_ACCESS_TOKEN];
    if (savedToken) {
        result = YES;
    }
    return result;
}

@end
