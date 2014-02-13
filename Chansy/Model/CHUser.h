//
//  CHUser.h
//  Chansy
//
//  Created by Vitaly Dyachkov on 09/02/14.
//  Copyright (c) 2014 Vitaly Dyachkov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CHForm, CHQuery;

@interface CHUser : NSObject

@property (nonatomic, copy) NSString *guid;
@property (nonatomic, strong) CHForm *form;
@property (nonatomic, strong) CHQuery *query;

@end
