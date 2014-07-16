//
//  LoginViewController.m
//  CharacterLab
//
//  Created by Veronica Zheng on 7/7/14.
//  Copyright (c) 2014 Dropbox. All rights reserved.
//

#import "CLColor.h"
#import "LoginViewController.h"
#import <Parse/Parse.h>

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *userNameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIView *loginViewBox;
@property (weak, nonatomic) IBOutlet UIView *passwordLine;
@property (weak, nonatomic) IBOutlet UIImageView *logo;

@property (weak, nonatomic) IBOutlet UIView *userNameLine;


- (IBAction)onTap:(UITapGestureRecognizer *)sender;

- (IBAction)onLogin:(id)sender;

@end


@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self registerForKeyboardNotifications];
    }
    return self;
}

- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromHEX(CLColorAquamarine);
   // self.loginButton.backgroundColor = UIColorFromHEX(CLColorPencilYellow);
    self.loginViewBox.layer.cornerRadius = 4;

    self.loginButton.layer.cornerRadius = 4.0;

    self.userNameField.delegate = self;
    self.passwordField.delegate = self;
//    self.userNameField.textColor = UIColorFromHEX(CLColorPencilYellow);
//    self.passwordField.textColor = UIColorFromHEX(CLColorPencilYellow);
    
    self.userNameLine.alpha = .75;
    self.passwordLine.alpha = .75;

  //  [self.userNameField becomeFirstResponder];
    
    
}


- (void)keyboardWasShown:(NSNotification*)aNotification {
//    NSDictionary* info = [aNotification userInfo];
//    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;

//    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
//    self.scrollView.contentInset = contentInsets;
//    self.scrollView.scrollIndicatorInsets = contentInsets;
//
//    CGRect aRect = self.view.frame;
//    aRect.size.height -= kbSize.height;
//    [self.scrollView scrollRectToVisible:self.loginButton.frame animated:YES];
    

      int verticalShift = 60;
    NSTimeInterval animationDuration =
    [[[aNotification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    

    
//    CGRect frame = self.view.frame;
//    frame.origin.y -= 60;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    self.loginButton.center = CGPointMake(self.loginButton.center.x, self.loginButton.center.y - 117);
    
    self.userNameLine.center = CGPointMake(self.userNameLine.center.x, self.userNameLine.center.y - verticalShift);
    self.userNameField.center = CGPointMake(self.userNameField.center.x, self.userNameField.center.y - verticalShift);
    
    self.passwordLine.center = CGPointMake(self.passwordLine.center.x, self.passwordLine.center.y - verticalShift);
    self.passwordField.center = CGPointMake(self.passwordField.center.x, self.passwordField.center.y - verticalShift);
    
    self.logo.center = CGPointMake(self.logo.center.x, self.logo.center.y - 35);

    
//    self.view.frame = frame;
    [UIView commitAnimations];
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    int verticalShift = 60;
    NSTimeInterval animationDuration =
    [[[aNotification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
//    CGRect frame = self.view.frame;
//    frame.origin.y += 60;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
//    self.view.frame = frame;
    self.loginButton.center = CGPointMake(self.loginButton.center.x, self.loginButton.center.y + 117);
    
    self.userNameLine.center = CGPointMake(self.userNameLine.center.x, self.userNameLine.center.y + verticalShift);
    self.userNameField.center = CGPointMake(self.userNameField.center.x, self.userNameField.center.y + verticalShift);
    
    self.passwordLine.center = CGPointMake(self.passwordLine.center.x, self.passwordLine.center.y + verticalShift);
    self.passwordField.center = CGPointMake(self.passwordField.center.x, self.passwordField.center.y + verticalShift);
    
    self.logo.center = CGPointMake(self.logo.center.x, self.logo.center.y + 35);
    
    [UIView commitAnimations];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.userNameField) {
        [self.passwordField becomeFirstResponder];
    } else if (textField == self.passwordField) {
        [textField resignFirstResponder];
        [self onLogin:self];
    }
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onTap:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
}

- (IBAction)onLogin:(id)sender {
    [self.userNameField resignFirstResponder];
    [self.passwordField resignFirstResponder];

    NSString *username = self.userNameField.text;
    NSString *password = self.passwordField.text;
    if (username && password && username.length > 0 && password.length > 0) {
        [PFUser logInWithUsernameInBackground:username
                                     password:password
                                        block:^(PFUser *user, NSError *error) {
                                            if (user) {
                                                [self.delegate userDidLogin];
                                            } else {
                                                [[[UIAlertView alloc] initWithTitle:@"Invalid login credentials"
                                                                            message:error.localizedDescription
                                                                           delegate:nil
                                                                  cancelButtonTitle:@"Ok"
                                                                  otherButtonTitles:nil] show];

                                            }
                                        }];
    } else {
        [[[UIAlertView alloc] initWithTitle:@"Missing Information"
                                    message:@"Username and password should not be empty."
                                   delegate:nil
                          cancelButtonTitle:@"Ok"
                          otherButtonTitles:nil] show];
    }
}

@end
