//
//  LoginViewController.m
//  CharacterLab
//
//  Created by Veronica Zheng on 7/7/14.
//  Copyright (c) 2014 Dropbox. All rights reserved.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>

@interface LoginViewController ()

@property (nonatomic, strong) PFUser *user;
@property (weak, nonatomic) IBOutlet UITextField *userNameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
- (IBAction)onSignup:(id)sender;
- (IBAction)onLogin:(id)sender;

@end


@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onSignup:(id)sender {
    self.user = [PFUser user];
    self.user.username = self.userNameField.text;
    self.user.password = self.passwordField.text;
    //self.user.email = @"email@example.com";
    //self.user[@"phone"] = @"415-392-0202";
    
    [self.user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            [self onLogin:sender];
        } else {
            NSString *errorString = [error userInfo][@"error"];
            NSLog(@"Error: %@", errorString);
        }
    }];

}

- (IBAction)onLogin:(id)sender {
    [PFUser logInWithUsernameInBackground:self.userNameField.text
                                 password:self.passwordField.text
                                    block:^(PFUser *user, NSError *error) {
                                        if (user) {
                                            self.user = user;
                                        } else {
                                            // The login failed. Check error to see why.
                                        }
                                    }];

}
@end
