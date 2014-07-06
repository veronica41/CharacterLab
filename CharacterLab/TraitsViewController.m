//
//  TraitsViewController.m
//  CharacterLab
//
//  Created by Rajeev Nayak on 7/8/14.
//  Copyright (c) 2014 Dropbox. All rights reserved.
//

#import "TraitsViewController.h"
#import "TraitViewController.h"
#import "Trait.h"
#import "StudentsViewController.h"
#import "UIColor+CharacterLab.h"

CGFloat const kVerticalMargin = 30;
CGFloat const kHorizontalMargin = 30;
CGFloat const kDistanceBetweenPages = 20;

@interface TraitsViewController ()

@property (weak, nonatomic) IBOutlet UIView *contentView;
- (IBAction)onStudentsButton:(id)sender;

@property (nonatomic, strong) MultiPageViewController *pageController;
@property (nonatomic, strong) NSArray *traits;

@end

@implementation TraitsViewController

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

    self.view.backgroundColor = [UIColor aquamarineColor];

    // init the page controller
    self.pageController = [[MultiPageViewController alloc] init];
    self.pageController.verticalMargin = kVerticalMargin;
    self.pageController.horizontalMargin = kHorizontalMargin;
    self.pageController.distanceBetweenPages = kDistanceBetweenPages;
    self.pageController.backgroundColor = [UIColor aquamarineColor];
    self.pageController.dataSource = self;

    // add it to the view
    [self addChildViewController:self.pageController];
    [self.contentView addSubview:self.pageController.view];
    self.pageController.view.frame = self.contentView.frame;
    [self.pageController didMoveToParentViewController:self];

    // fetch the traits
    [[Trait query] findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.traits = objects;
        [self.pageController reloadData];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - MultiPageViewControllerDataSource

- (NSInteger)numberOfPagesInPageViewController:(MultiPageViewController *)pageViewController {
    return self.traits.count;
}

- (UIViewController *)pageViewController:(MultiPageViewController *)pageViewController viewControllerAtIndex:(NSInteger)index {
    TraitViewController *vc = [[TraitViewController alloc] init];
    vc.trait = self.traits[index];
    return vc;
}

#pragma mark - event handlers

- (IBAction)onStudentsButton:(id)sender {
    StudentsViewController *vc = [[StudentsViewController alloc] init];
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nvc animated:YES completion:nil];
}

@end
