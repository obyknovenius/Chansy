//
//  CHAPIClient.h
//  Chansy
//
//  Created by Vitaly Dyachkov on 09/02/14.
//  Copyright (c) 2014 Vitaly Dyachkov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CHUser;

@interface CHAPIClient : NSObject

+ (id)sharedClient;

- (void)loginWithUserName:(NSString *)username
                 password:(NSString *)password
                 succsess:(void (^)(NSString *userId))success
                  failure:(void (^)(NSError *error))failure;

- (void)getMyInfoWithSuccess:(void (^)(CHUser *))success
                     failure:(void (^)(NSError *))failure;

@end
