//
//  CHLoginViewController.m
//  Chansy
//
//  Created by Vitaly Dyachkov on 09/02/14.
//  Copyright (c) 2014 Vitaly Dyachkov. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <RestKit/RestKit.h>

#import "CHLoginViewController.h"

#import "CHLoginState.h"
#import "CHUser.h"
#import "CHForm.h"

#import "CHAPIClient.h"

@interface CHLoginViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *formView;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation CHLoginViewController

#pragma mark - View lifecircle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.formView.layer.cornerRadius = 5.f;
    self.formView.layer.masksToBounds = YES;
    
    CALayer *separateLayer = [CALayer layer];
    separateLayer.backgroundColor = [[UIColor colorWithRed:230.f/255.f green:230.f/255.f blue:230.f/255.f alpha:1.f] CGColor];
    separateLayer.frame = CGRectMake(0.f,
                                     floor(CGRectGetHeight(self.formView.frame) / 2),
                                     CGRectGetWidth(self.formView.frame),
                                     1.f);
    [self.formView.layer addSublayer:separateLayer];
    
    self.loginButton.layer.cornerRadius = 5.f;
    self.loginButton.layer.masksToBounds = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard:)];
    
    [self.view addGestureRecognizer:tap];
    
#ifdef DEBUG
    self.emailTextField.text = @"user@example.com";
    self.passwordTextField.text = @"12345678";
#endif
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

#pragma mark - Actions

- (IBAction)loginButtonPressed:(UIButton *)sender
{
    if ([self.emailTextField.text length] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Email not filled"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    if ([self.passwordTextField.text length] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Password not filled"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    [self login];
}

- (void)dismissKeyboard:(UITapGestureRecognizer *)recognizer
{
    [self.view endEditing:YES];
}

#pragma mark - Main logic

- (void)login
{
    CHAPIClient *apiClient = [CHAPIClient sharedClient];
    
    void (^failure)(NSError *) = ^(NSError *error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:error.localizedDescription
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    };
    
    void (^successGetMyInfo)(CHUser *) = ^(CHUser *user) {
        if ([user.form.nickname length] == 0) {
            [self performSegueWithIdentifier:@"CreateProfileSegue" sender:self];
        } else {
            [self performSegueWithIdentifier:@"FriendsProfileSegue" sender:self];
        }
    };
    
    void (^successLogin)(NSString *) = ^(NSString *userId) {
        [apiClient getMyInfoWithSuccess:successGetMyInfo failure:failure];
    };
    
    [apiClient loginWithUserName:self.emailTextField.text
                        password:self.passwordTextField.text
                        succsess:successLogin
                         failure:failure];

}

#pragma mark - Text field delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.emailTextField)
        [self.passwordTextField becomeFirstResponder];
    else if (textField == self.passwordTextField)
        [self login];
    
    return YES;
}

#pragma mark - Appearence

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
