//
//  TraitsViewController.m
//  CharacterLab
//
//  Created by Rajeev Nayak on 7/8/14.
//  Copyright (c) 2014 Dropbox. All rights reserved.
//

#import "TraitsViewController.h"
#import "TraitViewController.h"
#import "StudentsViewController.h"
#import "CLColor.h"
#import "CLModel.h"

CGFloat const kTopMargin = 70;
CGFloat const kBottomMargin = 40;
CGFloat const kHorizontalMargin = 35;
CGFloat const kDistanceBetweenPages = 5;
CGFloat const kSecondaryPageScale = 0.85;

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

    self.view.backgroundColor = UIColorFromHEX(CLColorAquamarine);

    // init the page controller
    self.pageController = [[MultiPageViewController alloc] init];
    self.pageController.topMargin = kTopMargin;
    self.pageController.bottomMargin = kBottomMargin;
    self.pageController.horizontalMargin = kHorizontalMargin;
    self.pageController.distanceBetweenPages = kDistanceBetweenPages;
    self.pageController.secondaryPageScale = kSecondaryPageScale;
    self.pageController.backgroundColor = UIColorFromHEX(CLColorAquamarine);
    self.pageController.dataSource = self;

    // add it to the view
    [self addChildViewController:self.pageController];
    [self.contentView addSubview:self.pageController.view];
    self.pageController.view.frame = self.contentView.frame;
    [self.pageController didMoveToParentViewController:self];

    [[CLModel sharedInstance] getTraitsWitSuccess:^(NSArray *traitList) {
        self.traits = traitList;
        [self.pageController reloadData];
    } failure:^(NSError *error) {
        NSLog(@"Failure fetching trait list");
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

- (UIViewController<MultiPageViewControllerChild> *)pageViewController:(MultiPageViewController *)pageViewController viewControllerAtIndex:(NSInteger)index {
    TraitViewController *vc = [[TraitViewController alloc] init];
    vc.trait = self.traits[index];
    return vc;
}

#pragma mark - event handlers

- (IBAction)onStudentsButton:(id)sender {
    StudentsViewController *vc = [[StudentsViewController alloc] init];
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:vc animated:YES completion:nil];
}

@end
