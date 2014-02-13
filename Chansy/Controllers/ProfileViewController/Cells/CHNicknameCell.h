//
//  CHNicknameCell.h
//  Chansy
//
//  Created by Vitaly Dyachkov on 09/02/14.
//  Copyright (c) 2014 Vitaly Dyachkov. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CHAvatarDelegate;

@interface CHNicknameCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *setAvatarLabel;
@property (weak, nonatomic) IBOutlet UITextField *nicknameTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *genderSegmentControl;

@property (nonatomic, weak) id<CHAvatarDelegate>avatarDelegate;

@end

@protocol CHAvatarDelegate

- (void)setAvatarForCell:(CHNicknameCell *)cell;

@end