//
//  TraitViewController.m
//  CharacterLab
//
//  Created by Rajeev Nayak on 7/4/14.
//  Copyright (c) 2014 Dropbox. All rights reserved.
//

#import "CLColor.h"
#import "TraitViewController.h"
#import "TraitDetailViewController.h"

@interface TraitViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *exploreButton;
- (IBAction)onTap:(id)sender;

@end

@implementation TraitViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = UIColorFromHEX(CLColorBackgroundBeige);
    self.titleLabel.textColor = UIColorFromHEX(CLColorTextBrown);
    self.descriptionLabel.textColor = UIColorFromHEX(CLColorSubtextBrown);
    self.exploreButton.tintColor = UIColorFromHEX(CLColorAquamarine);

    // add a drop shadow
    CALayer *layer = self.view.layer;
    layer.shadowOffset = CGSizeMake(1, 1);
    layer.shadowColor = [[UIColor blackColor] CGColor];
    layer.shadowRadius = 1;
    layer.shadowOpacity = 0.2;
    // TODO(rajeev): figure this out if perf is bad
//    layer.shadowPath = [[UIBezierPath bezierPathWithRect:self.view.bounds] CGPath];

    self.titleLabel.text = self.trait.name;
    self.descriptionLabel.text = self.trait.desc;
    self.imageView.image = [UIImage imageNamed:self.trait.name];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - MultiPageViewControllerChild

- (void)pageViewController:(MultiPageViewController *)pageViewController didMoveToNumPagesFromCenter:(CGFloat)numPagesFromCenter {
    self.view.alpha = 1 - 0.4 * numPagesFromCenter;
}

#pragma mark - event handlers

- (IBAction)onTap:(id)sender {
    TraitDetailViewController *detailController = [[TraitDetailViewController alloc] init];
    detailController.trait = self.trait;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:detailController];
    [self presentViewController:navController animated:YES completion:nil];
}

@end
