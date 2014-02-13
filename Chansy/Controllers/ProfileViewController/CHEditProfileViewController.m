//
//  CHProfileViewController.m
//  Chansy
//
//  Created by Vitaly Dyachkov on 09/02/14.
//  Copyright (c) 2014 Vitaly Dyachkov. All rights reserved.
//

#import "CHEditProfileViewController.h"

#import "CHNicknameCell.h"
#import "CHDatePickerCell.h"
#import "CHTextViewCell.h"
#import "CHPlaceholderTextView.h"

@interface CHEditProfileViewController () <CHAvatarDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, UITextViewDelegate>

@property (nonatomic, assign, getter = isDatePickerCellHidden) BOOL datePickerCelLHidden;

@property (nonatomic, strong) CHNicknameCell *nicknameCell;
@property (nonatomic, strong) UITableViewCell *dateCell;
@property (nonatomic, strong) CHDatePickerCell *datePickerCell;
@property (nonatomic, strong) UITableViewCell *interestsCell;
@property (nonatomic, strong) CHTextViewCell *aboutMeCell;

@end

@implementation CHEditProfileViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        _datePickerCelLHidden = YES;
    }
    return self;
}

#pragma mark - View lifecircle

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.hidesBackButton = YES;
    
    // This will remove extra separators from tableview
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.nicknameCell = [self.tableView dequeueReusableCellWithIdentifier:@"NicknameCell"];
    self.nicknameCell.avatarDelegate = self;
    self.nicknameCell.nicknameTextField.delegate = self;
    [self.nicknameCell.nicknameTextField becomeFirstResponder];
    
    self.dateCell = [self.tableView dequeueReusableCellWithIdentifier:@"DateCell"];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.locale = [NSLocale currentLocale];
    formatter.dateStyle = NSDateFormatterMediumStyle;
    self.dateCell.detailTextLabel.text = [formatter stringFromDate:[NSDate date]];
    
    self.datePickerCell = [self.tableView dequeueReusableCellWithIdentifier:@"DatePickerCell"];
    
    self.interestsCell = [self.tableView dequeueReusableCellWithIdentifier:@"InterestsCell"];
    
    self.aboutMeCell = [self.tableView dequeueReusableCellWithIdentifier:@"AboutMeCell"];
}

#pragma mark - Actions

- (void)dismissKeyboard
{
    [self.view endEditing:YES];
}

- (IBAction)dateChanged:(UIDatePicker *)picker
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.locale = [NSLocale currentLocale];
    formatter.dateStyle = NSDateFormatterMediumStyle;
    self.dateCell.detailTextLabel.text = [formatter stringFromDate:picker.date];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.isDatePickerCellHidden ? 4 : 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            return self.nicknameCell;
            
        case 1:
            return self.dateCell;
            
        case 2: {
            if (!self.isDatePickerCellHidden) {
                return self.datePickerCell;
            } else {
                return self.interestsCell;
            }
        }
            
        case 3: {
            if (!self.isDatePickerCellHidden) {
                return self.interestsCell;
            } else {
                return self.aboutMeCell;
            }
        }
            
        case 4:
            return self.aboutMeCell;
    }
    
    return nil;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 100.f;
    }
    
    if (!self.isDatePickerCellHidden) {
        if (indexPath.row == 2) {
            return 216.f;
        }
        
        if (indexPath.row == 4) {
            return 115.f;
        }
    } else {
        if (indexPath.row == 3) {
            return 115.f;
        }
    }

    return 44.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self dismissKeyboard];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 1) {
        [tableView beginUpdates];
        
        if (self.datePickerCelLHidden) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
            [tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        } else {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
        
        self.datePickerCelLHidden = !self.datePickerCelLHidden;
        
        [tableView endUpdates];
    }
}

#pragma mark - Scroll view delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self dismissKeyboard];
}

#pragma mark - Avatar delegate

- (void)setAvatarForCell:(CHNicknameCell *)cell
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
	imagePicker.delegate = self;
    
    imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    imagePicker.allowsEditing = YES;
    
	[self presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark - Image picker controller delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	[picker dismissViewControllerAnimated:YES completion:nil];
    self.nicknameCell.setAvatarLabel.hidden = YES;
    self.nicknameCell.avatarImageView.image = [info objectForKey:UIImagePickerControllerEditedImage];
    [self.nicknameCell.nicknameTextField becomeFirstResponder];
}

#pragma mark - Text field delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.nicknameCell.nicknameTextField)
        [self.nicknameCell.nicknameTextField resignFirstResponder];
    
    return YES;
}

#pragma mark - Text view delegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

@end
