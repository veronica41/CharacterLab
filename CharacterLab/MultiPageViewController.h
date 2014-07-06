//
//  MultiPageViewController.h
//  CharacterLab
//
//  Created by Rajeev Nayak on 7/5/14.
//  Copyright (c) 2014 Dropbox. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MultiPageViewController;

@protocol MultiPageViewControllerDataSource <NSObject>

- (NSInteger)numberOfPagesInPageViewController:(MultiPageViewController *)pageViewController;
- (UIViewController *)pageViewController:(MultiPageViewController *)pageViewController viewControllerAtIndex:(NSInteger)index;

@end

@interface MultiPageViewController : UIViewController <UIScrollViewDelegate>

@property (nonatomic, assign) CGFloat verticalMargin;
@property (nonatomic, assign) CGFloat horizontalMargin;
@property (nonatomic, assign) CGFloat distanceBetweenPages;
@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) id <MultiPageViewControllerDataSource> dataSource;

- (void)reloadData;

@end
