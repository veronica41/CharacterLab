//
//  TraitViewController.m
//  CharacterLab
//
//  Created by Rajeev Nayak on 7/4/14.
//  Copyright (c) 2014 Dropbox. All rights reserved.
//

#import "TraitViewController.h"
#import "UIColor+CharacterLab.h"
#import "TraitDetailViewController.h"
#import <UIImageView+AFNetworking.h>

@interface TraitViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
- (IBAction)onActivities:(id)sender;

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
    [self.imageView setImageWithURL:[NSURL URLWithString:self.trait.imageUrl]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// (Veronica) add this to test my view, feel free to change
- (IBAction)onActivities:(id)sender {
    TraitDetailViewController *detailController = [[TraitDetailViewController alloc] init];
    detailController.trait = self.trait;
    [self presentViewController:detailController animated:YES completion:nil];
}

@end
