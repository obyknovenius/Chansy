//
//  CHForm.h
//  Chansy
//
//  Created by Vitaly Dyachkov on 09/02/14.
//  Copyright (c) 2014 Vitaly Dyachkov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CHForm : NSObject

@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, strong) NSNumber *sex;
@property (nonatomic, strong) NSDate *birth;
@property (nonatomic, strong) NSNumber *avatarId;
@property (nonatomic, copy) NSString *aboutMe;

@end
