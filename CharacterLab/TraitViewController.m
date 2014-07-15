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

CGFloat const kTransitionDuration = 0.5;

@interface TraitViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *exploreLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeight;
- (IBAction)onTap:(id)sender;

@property (nonatomic, assign) BOOL presentingVC;

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
    self.exploreLabel.textColor = UIColorFromHEX(CLColorAquamarine);

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

- (void)pageViewController:(MultiPageViewController *)pageViewController didMoveToNumPagesFromCenter:(CGFloat)numPagesFromCenter scaledBy:(CGFloat)scale {
    // fade out based on how far we are from the center
    self.view.alpha = 1 - 0.4 * numPagesFromCenter;

    // scale the views by the same amount the view controller was scaled
    self.titleLabel.font = [UIFont systemFontOfSize:30 * scale];
    self.descriptionLabel.font = [UIFont systemFontOfSize:15 * scale];
    self.exploreLabel.font = [UIFont systemFontOfSize:13 * scale];
    self.imageWidth.constant = 180 * scale;
    self.imageHeight.constant = 180 * scale;
    self.imageView.layer.cornerRadius = 90 * scale;
}

#pragma mark - event handlers

- (IBAction)onTap:(id)sender {
    TraitDetailViewController *detailController = [[TraitDetailViewController alloc] init];
    detailController.trait = self.trait;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:detailController];
    navController.modalPresentationStyle = UIModalPresentationCustom;
    navController.transitioningDelegate = self;
    [self presentViewController:navController animated:YES completion:nil];
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    self.presentingVC = true;
    return self;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    self.presentingVC = false;
    return self;
}

- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id <UIViewControllerAnimatedTransitioning>)animator {
    return nil;
}

- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator {
    return nil;
}

// This is used for percent driven interactive transitions, as well as for container controllers that have companion animations that might need to
// synchronize with the main animation.
- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return kTransitionDuration;
}

// This method can only  be a nop if the transition is interactive and not a percentDriven interactive transition.
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIView *containerView = [transitionContext containerView];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

    UIImageView *fromImageView;
    CGRect toFrame;
    CGFloat toCornerRadius;
    TraitDetailViewController *detailViewController;
    if (self.presentingVC) {
        detailViewController = (TraitDetailViewController *)((UINavigationController *)toViewController).topViewController;
        fromImageView = self.imageView;
        detailViewController.hideImageViewOnLoad = YES;
        toFrame = CGRectMake(0, 64, 320, 224);
        toCornerRadius = 0;

        [containerView addSubview:toViewController.view];
        toViewController.view.alpha = 0;
    } else {
        detailViewController = (TraitDetailViewController *)((UINavigationController *)fromViewController).topViewController;
        fromImageView = detailViewController.traitImageView;
        self.imageView.alpha = 0;
        toFrame = [self.imageView convertRect:self.imageView.bounds toView:containerView];
        toCornerRadius = self.imageView.layer.cornerRadius;
    }

    CGRect fromImageViewFrame = [fromImageView convertRect:fromImageView.bounds toView:containerView];
    UIImageView *animatingImageView = [[UIImageView alloc] initWithFrame:fromImageViewFrame];
    animatingImageView.clipsToBounds = fromImageView.clipsToBounds;
    animatingImageView.contentMode = fromImageView.contentMode;
    animatingImageView.image = fromImageView.image;
    animatingImageView.layer.cornerRadius = fromImageView.layer.cornerRadius;
    [containerView addSubview:animatingImageView];
    fromImageView.alpha = 0;

    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
    animation.timingFunction = [CAMediaTimingFunction     functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.fromValue = @(animatingImageView.layer.cornerRadius);
    animation.toValue = @(toCornerRadius);
    animation.duration = kTransitionDuration;
    animatingImageView.layer.cornerRadius = toCornerRadius;
    [animatingImageView.layer addAnimation:animation forKey:@"cornerRadius"];

    [UIView animateWithDuration:kTransitionDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        animatingImageView.frame = toFrame;
        fromViewController.view.alpha = 0;
        toViewController.view.alpha = 1;
    } completion:^(BOOL finished) {
        self.imageView.alpha = 1;
        detailViewController.traitImageView.alpha = 1;
        [animatingImageView removeFromSuperview];
        [transitionContext completeTransition:YES];
    }];
}

@end
