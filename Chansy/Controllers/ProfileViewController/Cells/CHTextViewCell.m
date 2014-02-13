//
//  CHTextViewCell.m
//  Chansy
//
//  Created by Vitaly Dyachkov on 09/02/14.
//  Copyright (c) 2014 Vitaly Dyachkov. All rights reserved.
//

#import "CHTextViewCell.h"

#import "CHPlaceholderTextView.h"

@implementation CHTextViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.textView.font = [UIFont systemFontOfSize:17.f];
    self.textView.placeholder = @"About me";
}

@end
