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
CGFloat const kMaxAnimatingImageRadius = 200;

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
    self.titleLabel.font = [UIFont fontWithName:@"Avenir" size:30 * scale];
    self.descriptionLabel.font = [UIFont fontWithName:@"Avenir" size:13 * scale];
    self.exploreLabel.font = [UIFont fontWithName:@"Avenir" size:13 * scale];
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

    // init from/to properties based on whether we're presenting or dismissing
    UIImageView *fromImageView;
    CGFloat fromRadius;
    UIImageView *toImageView;
    CGFloat toRadius;
    if (self.presentingVC) {
        [containerView addSubview:toViewController.view];
        toViewController.view.alpha = 0;

        TraitDetailViewController *detailViewController = (TraitDetailViewController *)((UINavigationController *)toViewController).topViewController;
        fromImageView = self.imageView;
        fromRadius = self.imageView.layer.cornerRadius;
        // reference detailViewController.view to trigger viewDidLoad so that we can get a reference to detailViewController.traitImageView
        detailViewController.view;
        toImageView = detailViewController.traitImageView;
        toRadius = kMaxAnimatingImageRadius;
    } else {
        TraitDetailViewController *detailViewController = (TraitDetailViewController *)((UINavigationController *)fromViewController).topViewController;
        fromImageView = detailViewController.traitImageView;
        fromRadius = kMaxAnimatingImageRadius;
        toImageView = self.imageView;
        toRadius = self.imageView.layer.cornerRadius;
    }

    // get the frames of fromImageView and toImageView in containerView's bounds
    CGRect fromImageViewFrame = [fromImageView convertRect:fromImageView.bounds toView:containerView];
    CGRect toImageViewFrame;
    // TODO(rajeev): this is hax, figure out why the rect isn't right
    if (self.presentingVC) {
        toImageViewFrame = CGRectMake(0, 64, 320, 224);
    } else {
        toImageViewFrame = [toImageView convertRect:toImageView.bounds toView:containerView];
    }

    // adjust the frames so that they both match the larger frame's x-bounds (so that the circle mask has room to grow horizontally)
    CGFloat minFrameX = MIN(fromImageViewFrame.origin.x, toImageViewFrame.origin.x);
    CGFloat maxFrameWidth = MAX(fromImageViewFrame.size.width, toImageViewFrame.size.width);
    CGRect fromFrame = CGRectMake(minFrameX, fromImageViewFrame.origin.y, maxFrameWidth, fromImageViewFrame.size.height);
    CGRect toFrame = CGRectMake(minFrameX, toImageViewFrame.origin.y, maxFrameWidth, toImageViewFrame.size.height);

    // init the animating image view
    UIImageView *animatingImageView = [[UIImageView alloc] initWithFrame:fromFrame];
    animatingImageView.clipsToBounds = YES;
    animatingImageView.contentMode = UIViewContentModeScaleAspectFill;
    animatingImageView.image = fromImageView.image;

    // mask a circular region of the image
    CAShapeLayer *circleMask = [CAShapeLayer layer];
    circleMask.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(fromFrame.size.width / 2 - fromRadius, fromFrame.size.height / 2 - fromRadius, 2 * fromRadius, 2 * fromRadius) cornerRadius:fromRadius].CGPath;
    animatingImageView.layer.mask = circleMask;

    // add the animating view directly to the container (on top of both view controllers) and hide the actual images
    [containerView addSubview:animatingImageView];
    fromImageView.alpha = 0;
    toImageView.alpha = 0;

    // animate the circular mask's size
    UIBezierPath *toPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(toFrame.size.width / 2 - toRadius, toFrame.size.height / 2 - toRadius, 2 * toRadius, 2 * toRadius) cornerRadius:toRadius];
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    pathAnimation.timingFunction = [CAMediaTimingFunction     functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pathAnimation.fromValue = (id)circleMask.path;
    pathAnimation.toValue = (id)toPath.CGPath;
    pathAnimation.duration = kTransitionDuration;
    circleMask.path = toPath.CGPath;
    [animatingImageView.layer.mask addAnimation:pathAnimation forKey:@"path"];

    // animate the actual views
    [UIView animateWithDuration:kTransitionDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        animatingImageView.frame = toFrame;
        fromViewController.view.alpha = 0;
        toViewController.view.alpha = 1;
    } completion:^(BOOL finished) {
        fromImageView.alpha = 1;
        toImageView.alpha = 1;
        [animatingImageView removeFromSuperview];
        [transitionContext completeTransition:YES];
    }];
}

@end
