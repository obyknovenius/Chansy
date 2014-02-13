//
//  CHNicknameCell.m
//  Chansy
//
//  Created by Vitaly Dyachkov on 09/02/14.
//  Copyright (c) 2014 Vitaly Dyachkov. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "CHNicknameCell.h"

@implementation CHNicknameCell

- (void)awakeFromNib
{
    self.avatarImageView.layer.cornerRadius = 40.f;
    self.avatarImageView.layer.masksToBounds = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(setAvatar:)];
    
    self.avatarImageView.userInteractionEnabled = YES;
    [self.avatarImageView addGestureRecognizer:tap];
}

- (void)setAvatar:(UIGestureRecognizer *)recognizer
{
    [self.avatarDelegate setAvatarForCell:self];
}

@end
