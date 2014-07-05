//
//  TraitsPageViewController.m
//  CharacterLab
//
//  Created by Rajeev Nayak on 7/4/14.
//  Copyright (c) 2014 Dropbox. All rights reserved.
//

#import "TraitsPageViewController.h"
#import "TraitViewController.h"

@interface TraitsPageViewController ()

@property (nonatomic, strong) NSArray *traits;

@end

@implementation TraitsPageViewController

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

    self.dataSource = self;

    [[Trait query] findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        for (Trait *trait in objects) {
            NSLog(@"trait %@", trait);
        }
        self.traits = objects;
        [self setViewControllers:@[[self viewControllerAtIndex:0]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    Trait *trait = ((TraitViewController *) viewController).trait;
    NSInteger index = [self.traits indexOfObject:trait];

    if (index == self.traits.count - 1) {
        return nil;
    } else {
        return [self viewControllerAtIndex:index + 1];
    }
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    Trait *trait = ((TraitViewController *) viewController).trait;
    NSInteger index = [self.traits indexOfObject:trait];

    if (index == 0) {
        return nil;
    } else {
        return [self viewControllerAtIndex:index - 1];
    }
}

- (TraitViewController *)viewControllerAtIndex:(NSUInteger)index {
    TraitViewController *vc = [[TraitViewController alloc] init];
    vc.trait = self.traits[index];
    return vc;
}

@end
