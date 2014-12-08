//
//  RedboothTests.m
//  TrackMyRadars
//
//  Created by Maria Bernis on 05/12/14.
//  Copyright (c) 2014 mariabernis. All rights reserved.
//
#import <Kiwi/Kiwi.h>
#import "MBCheck.h"
#import "RedboothAPIClient.h"

#define RB_API_BASE_URL     @"https://redbooth.com"
#define RB_API_CLIENT       @"56b67669c4c3251ca5aa45f1509526ef8eddff006956de014daa8b035b24dbd8"
#define RB_API_SECRET       @"6c97be47b73147bb7af8ff3f1ddeb04aeda1b1b62666744aa9b3622105c1301f"

#define KEY_ACCESS_TOKEN    @"access_token"
#define KEY_TOKEN_EXPIRES   @"access_token_expires"
#define KEY_REFRESH_TOKEN   @"refresh_token"

#define RB_API_HOST         @"redbooth.com"


SPEC_BEGIN(APIAuthorization)

describe(@"When checking API authorization for the app", ^{
    
    context(@"If app launches the first time after clean install", ^{
        
        NSString *savedVersion = [MBCheck lastOpenedAppVersion];
        AFOAuthCredential *savedCredential = [AFOAuthCredential retrieveCredentialWithIdentifier:RB_API_HOST];
        beforeAll(^{
            // Simulate firs time launch
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"last_opened_version"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        });
        
        afterAll(^{
            // Leave everything as it was
            if(savedVersion) {
                [[NSUserDefaults standardUserDefaults] setObject:savedVersion forKey:KEY_APP_LAST_OPENED_VERSION];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            if(savedCredential) {
                [AFOAuthCredential storeCredential:savedCredential withIdentifier:RB_API_HOST];
            }
            
        });
        
        it(@"Should have no credentials", ^{
            
            RedboothAPIClient *apiClient = [[RedboothAPIClient alloc] initWithBaseURL:[NSURL URLWithString:RB_API_BASE_URL] clientID:RB_API_CLIENT secret:RB_API_SECRET];
            [[theValue(apiClient.isAuthorised) should] beFalse];
            [[[AFOAuthCredential retrieveCredentialWithIdentifier:apiClient.serviceProviderIdentifier] should] beNil];
        });
    });
    
    context(@"If not first launch and the app previously got a credential", ^{
        
        AFOAuthCredential *savedCredential = [AFOAuthCredential retrieveCredentialWithIdentifier:RB_API_HOST];
        beforeAll(^{
            // Simulate we have credential
            if(!savedCredential) {
                AFOAuthCredential *credential = [AFOAuthCredential credentialWithOAuthToken:@"297491292983" tokenType:@"Bearer"];
                [AFOAuthCredential storeCredential:credential withIdentifier:RB_API_HOST];
            }
        });
        
        afterAll(^{
            // Leave everything as it was
            [AFOAuthCredential deleteCredentialWithIdentifier:RB_API_HOST];
            if(savedCredential) {
                [AFOAuthCredential storeCredential:savedCredential withIdentifier:RB_API_HOST];
            }
            
        });
        
        it(@"Should have authorization", ^{
            
            RedboothAPIClient *apiClient = [[RedboothAPIClient alloc] initWithBaseURL:[NSURL URLWithString:RB_API_BASE_URL] clientID:RB_API_CLIENT secret:RB_API_SECRET];
            [[theValue(apiClient.isAuthorised) should] beTrue];
            [[[AFOAuthCredential retrieveCredentialWithIdentifier:apiClient.serviceProviderIdentifier] shouldNot] beNil];
        });
    });
    
    context(@"If not first launch and the app didn't previously got a credential", ^{
        
        AFOAuthCredential *savedCredential = [AFOAuthCredential retrieveCredentialWithIdentifier:RB_API_HOST];
        beforeAll(^{
            // Simulate we don't have credential
            [AFOAuthCredential deleteCredentialWithIdentifier:RB_API_HOST];
        });
        
        afterAll(^{
            // Leave everything as it was
            if(savedCredential) {
                [AFOAuthCredential storeCredential:savedCredential withIdentifier:RB_API_HOST];
            }
            
        });
        
        it(@"Should have authorization", ^{
            
            RedboothAPIClient *apiClient = [[RedboothAPIClient alloc] initWithBaseURL:[NSURL URLWithString:RB_API_BASE_URL] clientID:RB_API_CLIENT secret:RB_API_SECRET];
            [[theValue(apiClient.isAuthorised) should] beFalse];
            [[[AFOAuthCredential retrieveCredentialWithIdentifier:apiClient.serviceProviderIdentifier] should] beNil];
        });
    });

});

SPEC_END
