//
//  RedboothAPIClient.m
//  TrackMyRadars
//
//  Created by Maria Bernis on 03/12/14.
//  Copyright (c) 2014 mariabernis. All rights reserved.
//

#import "RedboothAPIClient.h"
#import "MBCheck.h"

// Constants
#define RB_API_BASE_URL     @"https://redbooth.com"
#define RB_API_CLIENT       @"56b67669c4c3251ca5aa45f1509526ef8eddff006956de014daa8b035b24dbd8"
#define RB_API_SECRET       @"6c97be47b73147bb7af8ff3f1ddeb04aeda1b1b62666744aa9b3622105c1301f"
#define RB_API_CALLBACK_URL @"http://www.laurarocacodina.com/authcode.html"

#define KEY_ACCESS_TOKEN    @"access_token"
#define KEY_TOKEN_EXPIRES   @"access_token_expires"
#define KEY_REFRESH_TOKEN   @"refresh_token"


@interface RedboothAPIClient ()
@property (nonatomic, strong) AFOAuthCredential *credential;
@end

@implementation RedboothAPIClient

#pragma mark - Singleton instance
+ (instancetype)sharedInstance {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] initWithBaseURL:[NSURL URLWithString:RB_API_BASE_URL] clientID:RB_API_CLIENT secret:RB_API_SECRET];
    });
    return sharedInstance;
}

//- (instancetype)initWithSessionConfiguration:(NSURLSessionConfiguration *)configuration {
//    self = [super initWithSessionConfiguration:configuration];
//    if (self) {
//        [self setServiceProviderIdentifier:[[self baseURL] host]];
//        [self setClientID:RB_API_CLIENT];
//        [self setSecret:RB_API_SECRET];
//    }
//    return self;
//}

- (id)initWithBaseURL:(NSURL *)url clientID:(NSString *)clientID secret:(NSString *)secret {
    self = [super initWithBaseURL:url clientID:clientID secret:secret];
    if (self) {
        BOOL isFirstLaunch = [MBCheck isFirstTimeAppLaunch];
        if (isFirstLaunch) {
            // Clear credentials in keychain
            [AFOAuthCredential deleteCredentialWithIdentifier:self.serviceProviderIdentifier];
            return self;
        }
        
        AFOAuthCredential *savedCredential = [AFOAuthCredential retrieveCredentialWithIdentifier:self.serviceProviderIdentifier];
        if (savedCredential) {
            self.credential = savedCredential;
            [self setAuthorizationHeaderWithCredential:savedCredential];
        }
    }
    return self;
}

- (void)setCredential:(AFOAuthCredential *)credential {
    _credential = credential;
    _authorised = credential ? YES : NO;
}


- (NSURLSessionDataTask *)GET:(NSString *)URLString parameters:(id)parameters completion:(void (^)(NSURLSessionDataTask *tast, id responseObject, NSError *error))completion {
    
    NSURLSessionDataTask *task = [self GET:URLString
                                parameters:parameters
                                   success:^(NSURLSessionDataTask *task, id responseObject) {
                                       if (completion) {
                                           completion(task, responseObject, nil);
                                       }
                                   }
                                   failure:^(NSURLSessionDataTask *task, NSError *error) {
                                       if (error.code == 401) {
                                           // Refresh token
                                       } else {
                                           if (completion) {
                                               completion(task, nil, error);
                                           }
                                       }
                                   }];
    return task;
}

//- (NSURLSessionDataTask *)POST:(NSString *)URLString parameters:(id)parameters success:(void (^)(NSURLSessionDataTask *, id))success failure:(void (^)(NSURLSessionDataTask *, NSError *))failure {}
//
//- (NSURLSessionDataTask *)PUT:(NSString *)URLString parameters:(id)parameters success:(void (^)(NSURLSessionDataTask *, id))success failure:(void (^)(NSURLSessionDataTask *, NSError *))failure {}


#pragma mark - Authentication

- (void)launchAuthorizationFlow {
    
    NSString *baseAuthURLStr = @"https://redbooth.com/oauth2/authorize";
    NSString *params = [NSString stringWithFormat:@"client_id=%@&redirect_uri=%@&response_type=code", RB_API_CLIENT, RB_API_CALLBACK_URL];
    NSString *scapedParams = [params stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    NSString *authURLStr = [NSString stringWithFormat:@"%@?%@", baseAuthURLStr, scapedParams];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:authURLStr]];
}


//- (void)handleAuthoriseCallback:(NSString *)urlParams {
//    
//    NSArray *params = [urlParams componentsSeparatedByString:@"&"];
//    
//    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
//    [params enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//        NSArray *keyValue = [(NSString *)obj componentsSeparatedByString:@"="];
//        NSString *key = [keyValue[0] stringByRemovingPercentEncoding];
//        NSString *value = [keyValue[1] stringByRemovingPercentEncoding];
//        [paramsDict setObject:value forKey:key];
//    }];
//    
//    NSLog(@"🐼 Auth info: %@", paramsDict);
//    
//    NSString *token = [paramsDict objectForKey:@"access_token"];
//    if (token) {
//        [self setAuthorizationHeaderWithToken:token];
////        [self storeToken:token];
//    } else {
////        NSString *code = [paramsDict objectForKey:@"code"];
////        ((AppDelegate *)[UIApplication sharedApplication].delegate).window.rootViewController;
////        [self authoriseWithCode:code];
//    }
//    
//}

- (void)authoriseWithCode:(NSString *)code completion:(void(^)(NSError *error))completion {
    
    [self authenticateUsingOAuthWithPath:@"/oauth2/token"
                                    code:code
                             redirectURI:RB_API_CALLBACK_URL
                                 success:^(AFOAuthCredential *credential) {
                                     [AFOAuthCredential storeCredential:credential
                                                         withIdentifier:self.serviceProviderIdentifier];
                                     NSLog(@"Login succeded");
                                     if (completion) {
                                         completion(nil);
                                     }
                                 }
                                 failure:^(NSError *error) {
                                     NSLog(@"Login failed");
                                     if (self.credential) {
                                         self.credential = nil;
                                     }
                                     [AFOAuthCredential deleteCredentialWithIdentifier:self.serviceProviderIdentifier];
                                     if (completion) {
                                         completion(error);
                                     }
                                 }];
}

- (void)refreshToken {
//    GROAuth2SessionManager *sessionManager = [GROAuth2SessionManager managerWithBaseURL:[self baseURL]
//                                                                               clientID:RB_API_CLIENT
//                                                                                 secret:RB_API_SECRET];
//    [sessionManager authenticateUsingOAuthWithPath:@"/oauth2/token" refreshToken:<#(NSString *)#> success:<#^(AFOAuthCredential *credential)success#> failure:<#^(NSError *error)failure#>]
}

//- (void)setAuthorizationHeaderWithToken:(NSString *)token {
//    [self.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@", token]
//                  forHTTPHeaderField:@"Authorization"];
//}

//- (void)storeCredential:(AFOAuthCredential *)credential {
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSMutableDictionary *credentialInfo = [[NSMutableDictionary alloc] init];
//    [credentialInfo setObject:credential.accessToken forKey:KEY_ACCESS_TOKEN];
//    [credentialInfo setObject:credential.refreshToken forKey:KEY_REFRESH_TOKEN];
//    [credentialInfo setObject:credential.expiration forKey:KEY_TOKEN_EXPIRES];
//    
//    [defaults setObject:credentialInfo forKey:self.serviceProviderIdentifier];
//    [defaults synchronize];
//}

//- (AFOAuthCredential *)retrieveCredential {
//    
//    AFOAuthCredential *stored = nil;
//    NSDictionary *credentialInfo = [[NSUserDefaults standardUserDefaults] objectForKey:self.serviceProviderIdentifier];
//    if (credentialInfo && [credentialInfo objectForKey:KEY_ACCESS_TOKEN]) {
//        NSString *token = [credentialInfo objectForKey:KEY_ACCESS_TOKEN];
////        stored = [AFOAuthCredential credentialWithOAuthToken:token tokenType:<#(NSString *)#>];
//    }
//    return stored;
//}
//
//- (BOOL)hasStoredToken {
//    BOOL result = NO;
//    NSString *savedToken = [[NSUserDefaults standardUserDefaults] stringForKey:KEY_ACCESS_TOKEN];
//    if (savedToken) {
//        result = YES;
//    }
//    return result;
//}

@end
