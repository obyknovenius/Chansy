//
//  CHAPIClient.m
//  Chansy
//
//  Created by Vitaly Dyachkov on 09/02/14.
//  Copyright (c) 2014 Vitaly Dyachkov. All rights reserved.
//

#import <RestKit/RestKit.h>

#import "CHAPIClient.h"

#import "CHLoginState.h"
#import "CHUser.h"
#import "CHForm.h"
#import "CHQuery.h"

static NSString * const errorDomain = @"com.firstlinesoftware.Chancy";

enum ErrorCodes {
    kServerErrorCode
};

@implementation CHAPIClient

+ (id)sharedClient
{
    static CHAPIClient *sharedClient = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedClient = [[self alloc] init];
    });
    
    return sharedClient;
}

- (id)init
{
    if (self = [super init]) {
        
        RKLogConfigureByName("RestKit/Network*", RKLogLevelTrace);
        RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelTrace);
        
        //let AFNetworking manage the activity indicator
        [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
        
        // Initialize HTTPClient
        NSURL *baseURL = [NSURL URLWithString:@"http://bledate.notffirk.info:3000"];
        AFHTTPClient* client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
        
        //we want to work with JSON-Data
        [client setDefaultHeader:@"Accept" value:RKMIMETypeJSON];
        
        // Initialize RestKit
        RKObjectManager *objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];
        
        RKObjectMapping *loginStateMapping = [RKObjectMapping mappingForClass:[CHLoginState class]];
        [loginStateMapping addAttributeMappingsFromDictionary:@{
                                                                @"Success" : @"success",
                                                                @"ErrorMessage" : @"errorMessage",
                                                                @"UserId" : @"userId"
                                                                }];
        
        RKResponseDescriptor *registerResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:loginStateMapping
                                                                                                        method:RKRequestMethodGET
                                                                                                   pathPattern:@"/rest/register"
                                                                                                       keyPath:nil
                                                                                                   statusCodes:[NSIndexSet indexSetWithIndex:200]];
        [objectManager addResponseDescriptor:registerResponseDescriptor];
        
        RKObjectMapping *formMapping = [RKObjectMapping mappingForClass:[CHForm class]];
        [formMapping addAttributeMappingsFromDictionary:@{
                                                          @"Nickname" : @"nickname",
                                                          @"Sex" : @"sex",
                                                          @"Birth" : @"birth",
                                                          @"AvatarId" : @"avatarId",
                                                          @"AboutMe" : @"aboutMe"
                                                          }];
        
        RKObjectMapping *queryMapping = [RKObjectMapping mappingForClass:[CHQuery class]];
        [queryMapping addAttributeMappingsFromDictionary:@{
                                                           @"AgeFrom" : @"ageFrom",
                                                           @"AgeTo" : @"ageTo"
                                                           }];
        
        RKObjectMapping *userMapping = [RKObjectMapping mappingForClass:[CHUser class]];
        [userMapping addAttributeMappingsFromDictionary:@{
                                                          @"Id" : @"guid"
                                                          }];
        
        
        RKRelationshipMapping *userFormRelationshipMapping = [RKRelationshipMapping relationshipMappingFromKeyPath:@"Form" toKeyPath:@"form" withMapping:formMapping];
        [userMapping addPropertyMapping:userFormRelationshipMapping];
        
        RKRelationshipMapping *userQueryRelationshipMapping = [RKRelationshipMapping relationshipMappingFromKeyPath:@"Query" toKeyPath:@"query" withMapping:queryMapping];
        [userMapping addPropertyMapping:userQueryRelationshipMapping];
        
        
        RKResponseDescriptor *userResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:userMapping
                                                                                                    method:RKRequestMethodGET
                                                                                               pathPattern:@"/rest/me"
                                                                                                   keyPath:nil
                                                                                               statusCodes:[NSIndexSet indexSetWithIndex:200]];
        [objectManager addResponseDescriptor:userResponseDescriptor];
    }
    
    return self;
}

- (void)loginWithUserName:(NSString *)username
                 password:(NSString *)password
                 succsess:(void (^)(NSString *userId))success
                  failure:(void (^)(NSError *error))failure
{
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    
    [objectManager getObject:nil
                        path:@"/rest/register"
                  parameters:@{@"email": username, @"password": password}
                     success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                         CHLoginState *loginState = [mappingResult firstObject];
                         
                         if (![loginState.success boolValue]) {
                             NSString *errorMessage = [NSString stringWithFormat:@"Server error: %@", loginState.errorMessage];
                             NSDictionary *userInfo = @{NSLocalizedDescriptionKey: errorMessage};
                             NSError *error = [NSError errorWithDomain:errorDomain code:kServerErrorCode userInfo:userInfo];
                             
                             failure(error);
                             return;
                         }
                         
                         success(loginState.userId);
                     }
                     failure:^(RKObjectRequestOperation *operation, NSError *error) {
                         failure(error);
                     }];
}

- (void)getMyInfoWithSuccess:(void (^)(CHUser *))success
                     failure:(void (^)(NSError *))failure
{
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    
    [objectManager getObject:nil
                        path:@"/rest/me"
                  parameters:nil
                     success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                         CHUser *user = [mappingResult firstObject];
                         
                         success(user);
                     }
                     failure:^(RKObjectRequestOperation *operation, NSError *error) {
                         failure(error);
                     }];
}

@end
