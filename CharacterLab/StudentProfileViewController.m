//
//  StudentProfileViewController.m
//  CharacterLab
//
//  Created by Pierpaolo Baccichet on 7/6/14.
//  Copyright (c) 2014 Dropbox. All rights reserved.
//

#import "StudentProfileViewController.h"
#import "UIImageView+AFNetworking.h"

@interface StudentProfileViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation StudentProfileViewController

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
    [self.profileImage setImageWithURL:[NSURL URLWithString:self.student.photoUrl]];
    self.nameLabel.text = self.student.name;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
