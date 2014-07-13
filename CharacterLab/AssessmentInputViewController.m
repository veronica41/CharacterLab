//
//  AssessmentInputViewController.m
//  CharacterLab
//
//  Created by Pierpaolo Baccichet on 7/12/14.
//  Copyright (c) 2014 Dropbox. All rights reserved.
//

#import "AssessmentInputViewController.h"
#import "CLColor.h"

@interface AssessmentInputViewController ()

@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;

- (IBAction)onCancel:(UIButton *)sender;
- (IBAction)onDone:(UIButton *)sender;

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
    self.view.backgroundColor = UIColorFromHEX(CLColorGray);
    self.doneButton.backgroundColor = UIColorFromHEX(CLColorBlastOffRed);
    self.cancelButton.backgroundColor = UIColorFromHEX(CLColorBlastOffRed);
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
