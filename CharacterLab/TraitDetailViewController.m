//
//  TraitDetailViewController.m
//  CharacterLab
//
//  Created by Veronica Zheng on 7/7/14.
//  Copyright (c) 2014 Dropbox. All rights reserved.
//

#import "TraitDetailViewController.h"
#import "StudentsCollectionViewCell.h"
#import "CLColor.h"

@interface TraitDetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *traitImageView;
@property (weak, nonatomic) IBOutlet UILabel *traitDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *aboutLabel;
@property (weak, nonatomic) IBOutlet UIView *movieView;
@property (weak, nonatomic) IBOutlet UILabel *buildLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *buildTraitViewHeight;


@end


@implementation TraitDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // setup navigation bar
    self.navigationController.navigationBar.barTintColor = UIColorFromHEX(CLColorBackgroundBeige);
    self.navigationController.navigationBar.tintColor = UIColorFromHEX(CLColorTextBrown);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_navBackLight"] style:UIBarButtonItemStylePlain target:self action:@selector(onBackButton:)];
    self.navigationItem.title = self.trait.name;

    self.traitImageView.image = [UIImage imageNamed:self.trait.name];
    self.traitDescriptionLabel.text = self.trait.desc;
    self.aboutLabel.text = [NSString stringWithFormat:@"ABOUT %@", self.trait.name.uppercaseString];
    self.buildLabel.text = [NSString stringWithFormat:@"BUILD %@", self.trait.name.uppercaseString];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onBackButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
