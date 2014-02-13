//
//  CHTextViewCell.h
//  Chansy
//
//  Created by Vitaly Dyachkov on 09/02/14.
//  Copyright (c) 2014 Vitaly Dyachkov. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CHPlaceholderTextView;

@interface CHTextViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet CHPlaceholderTextView *textView;

@end
