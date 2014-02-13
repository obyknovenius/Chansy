//
//  CHLoginState.h
//  Chansy
//
//  Created by Vitaly Dyachkov on 09/02/14.
//  Copyright (c) 2014 Vitaly Dyachkov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CHLoginState : NSObject

@property (nonatomic, strong) NSNumber *success;
@property (nonatomic, copy) NSString *errorMessage;
@property (nonatomic, copy) NSString *userId;

@end
