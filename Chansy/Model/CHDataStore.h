//
//  CHDataStore.h
//  Chansy
//
//  Created by Vitaly Dyachkov on 09/02/14.
//  Copyright (c) 2014 Vitaly Dyachkov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CHUser;

@interface CHDataStore : NSObject

+ (id)sharedStore;

@property (nonatomic, strong) CHUser *user;
@property (nonatomic, strong) NSArray *friends;
@property (nonatomic, strong) NSArray *interests;

@end
