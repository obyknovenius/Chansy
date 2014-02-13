//
//  CHDataStore.m
//  Chansy
//
//  Created by Vitaly Dyachkov on 09/02/14.
//  Copyright (c) 2014 Vitaly Dyachkov. All rights reserved.
//

#import "CHDataStore.h"

@implementation CHDataStore

+ (id)sharedStore
{
    static CHDataStore *sharedStore = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedStore = [[self alloc] init];
    });
    
    return sharedStore;
}

@end
