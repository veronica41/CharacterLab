//
//  MultiPageViewController.m
//  CharacterLab
//
//  Created by Rajeev Nayak on 7/5/14.
//  Copyright (c) 2014 Dropbox. All rights reserved.
//

#import "MultiPageViewController.h"
#import "TouchInterceptingContainerView.h"

@interface MultiPageViewController ()

@property (weak, nonatomic) IBOutlet TouchInterceptingContainerView *containerView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewTopMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewBottomMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewLeftMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewRightMargin;

@property (nonatomic, assign) NSInteger numPages;
@property (nonatomic, strong) NSDictionary *visibleViewControllersByIndex;

@end

@implementation MultiPageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.numPages = 0;
        self.visibleViewControllersByIndex = @{};
    }
    return self;
}

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.containerView.backgroundColor = self.backgroundColor;
    self.containerView.contentView = self.scrollView;

    self.scrollView.backgroundColor = self.backgroundColor;
    self.scrollView.delegate = self;

    self.scrollViewTopMargin.constant = self.verticalMargin;
    self.scrollViewBottomMargin.constant = self.verticalMargin;

    // subtract half the distance between pages from each side since each child view controller will be horizontally inset by that distance
    self.scrollViewLeftMargin.constant = self.horizontalMargin - self.distanceBetweenPages / 2;
    self.scrollViewRightMargin.constant = self.horizontalMargin - self.distanceBetweenPages / 2;

    self.pageControl.currentPage = 0;

    [self reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self refreshVisiblePages];
}

#pragma mark - helpers

- (void)reloadData {
    self.numPages = [self.dataSource numberOfPagesInPageViewController:self];
    self.pageControl.numberOfPages = self.numPages;

    // resize the scroll view to fit the new number of pages
    CGFloat contentWidth = self.numPages * CGRectGetWidth(self.scrollView.frame);
    CGFloat contentHeight = CGRectGetHeight(self.scrollView.frame);
    self.scrollView.contentSize = CGSizeMake(contentWidth, contentHeight);

    [self refreshVisiblePages];
}

- (void)refreshVisiblePages {
    // return early if there aren't any pages
    if (self.numPages == 0) {
        return;
    }

    // calculate where the horizontal edges of the viewport lie in the scroll view's coordinate system
    CGFloat width = CGRectGetWidth(self.scrollView.frame);
    CGFloat minX = self.scrollView.contentOffset.x - self.scrollViewLeftMargin.constant;
    CGFloat maxX = self.scrollView.contentOffset.x + width + self.scrollViewRightMargin.constant - 1;

    // get the indices of the first/last pages that should be visible now
    int firstVisibleIndex = MAX(floor(minX / width), 0);
    int lastVisibleIndex = MIN(floor(maxX / width), self.numPages - 1);

    // add pages that just became visible
    NSMutableDictionary *visibleViewControllersByIndex = [[NSMutableDictionary alloc] init];
    for (int i = firstVisibleIndex; i <= lastVisibleIndex; i++) {
        UIViewController *vc = [self.visibleViewControllersByIndex objectForKey:@(i)];
        if (vc == nil) {
            NSInteger index = [@(i) integerValue];
            vc = [self.dataSource pageViewController:self viewControllerAtIndex:index];
            [self addViewController:vc atIndex:index];
        }
        [visibleViewControllersByIndex setObject:vc forKey:@(i)];
    }

    // remove pages that are no longer visible
    for (id index in self.visibleViewControllersByIndex) {
        if ([visibleViewControllersByIndex objectForKey:index] == nil) {
            [self removeViewController:[self.visibleViewControllersByIndex objectForKey:index]];
        };
    }

    // update the page control
    int currentPage = floor((self.scrollView.contentOffset.x + width / 2) / width);
    self.pageControl.currentPage = MIN(MAX(currentPage, 0), self.numPages - 1);

    self.visibleViewControllersByIndex = visibleViewControllersByIndex;
}

- (void)addViewController:(UIViewController *)vc atIndex:(NSInteger)index {
    [self addChildViewController:vc];
    [self.scrollView addSubview:vc.view];
    CGFloat width = CGRectGetWidth(self.scrollView.frame);
    CGFloat height = CGRectGetHeight(self.scrollView.frame);
    // inset the view horizontally to create the proper distance between pages
    vc.view.frame = CGRectMake(index * width + self.distanceBetweenPages / 2, 0, width - self.distanceBetweenPages, height);
    [vc didMoveToParentViewController:self];
}

- (void)removeViewController:(UIViewController *)vc {
    [vc willMoveToParentViewController:nil];
    [vc.view removeFromSuperview];
    [vc removeFromParentViewController];
}

//- (void)repositionVisibleViewControllers {
//    CGFloat width = CGRectGetWidth(self.scrollView.frame);
//    CGFloat height = CGRectGetHeight(self.scrollView.frame);
//    CGFloat centerX = self.scrollView.contentOffset.x + width / 2;
//    for (id key in self.visibleViewControllersByIndex) {
//        int index = [key intValue];
//        UIViewController *vc = [self.visibleViewControllersByIndex objectForKey:key];
//        CGFloat vcCenterX = index * width + width / 2;
//        CGFloat distanceFromCenter = ABS(vcCenterX - centerX);
//        CGFloat scale = 0.7 + 0.2 * (1 - distanceFromCenter / 320);
//        CGFloat margin = (1 - scale) * width / 2;
//        vc.view.frame = CGRectMake(index * width + margin, margin, width - 2 * margin, height - 2 * margin);
//    }
//}

@end
