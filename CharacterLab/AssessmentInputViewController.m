//
//  AssessmentInputViewController.m
//  CharacterLab
//
//  Created by Pierpaolo Baccichet on 7/12/14.
//  Copyright (c) 2014 Dropbox. All rights reserved.
//

#import "AssessmentInputViewController.h"
#import "UIColor+CharacterLab.h"

@interface AssessmentInputViewController ()

- (IBAction)onCancel:(UIButton *)sender;
- (IBAction)onDone:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;

@end

@implementation AssessmentInputViewController

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
    self.view.backgroundColor = [UIColor CLBackgroundGrayColor];
    self.doneButton.backgroundColor =  [UIColor CLRedButtonColor];
    self.cancelButton.backgroundColor = [UIColor CLRedButtonColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onCancel:(UIButton *)sender {
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onDone:(UIButton *)sender {
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}
@end
