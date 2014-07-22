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

CGFloat const kZoomTransitionDuration = 0.4;
CGFloat const kSlide1TransitionDuration = 0.25;
CGFloat const kSlide2TransitionDuration = 0.25;
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
    self.descriptionLabel.font = [UIFont fontWithName:@"Avenir" size:14 * scale];
    self.exploreLabel.font = [UIFont fontWithName:@"Avenir-Heavy" size:14 * scale];
    self.imageWidth.constant = 180 * scale;
    self.imageHeight.constant = 180 * scale;
    self.imageView.layer.cornerRadius = 90 * scale;
}

#pragma mark - event handlers

- (IBAction)onTap:(id)sender {
    TraitDetailViewController *detailController = [[TraitDetailViewController alloc] init];
    detailController.trait = self.trait;
    detailController.modalPresentationStyle = UIModalPresentationCustom;
    detailController.transitioningDelegate = self;
    [self presentViewController:detailController animated:YES completion:nil];
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
    return self.presentingVC ? kZoomTransitionDuration + kSlide1TransitionDuration + kSlide2TransitionDuration : kZoomTransitionDuration;
}

// This method can only  be a nop if the transition is interactive and not a percentDriven interactive transition.
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIView *containerView = [transitionContext containerView];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

    NSData *tempArchiveView = [NSKeyedArchiver archivedDataWithRootObject:self.view];
    CGRect viewFrame = [self.view convertRect:self.view.bounds toView:containerView];

    UIView *animatingBackgroundView = [NSKeyedUnarchiver unarchiveObjectWithData:tempArchiveView];
    [animatingBackgroundView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    animatingBackgroundView.layer.cornerRadius = self.view.layer.cornerRadius;
    [containerView addSubview:animatingBackgroundView];

    UIView *viewWithOnlyTextSubviews = [NSKeyedUnarchiver unarchiveObjectWithData:tempArchiveView];
    UIView *subview = viewWithOnlyTextSubviews.subviews[0];
    for (UIView *view in subview.subviews) {
        if([view isKindOfClass:[UIImageView class]]){
            view.alpha = 0;
            break;
        }
    }
    viewWithOnlyTextSubviews.backgroundColor = [UIColor clearColor];
    viewWithOnlyTextSubviews.frame = viewFrame;
    [containerView addSubview:viewWithOnlyTextSubviews];

    // init from/to properties based on whether we're presenting or dismissing
    TraitDetailViewController *detailViewController;
    CGRect fromBackgroundFrame;
    CGRect toBackgroundFrame;
    CGFloat fromTextSubviewsAlpha;
    CGFloat toTextSubviewsAlpha;
    CGFloat fromTitleBarAlpha;
    CGFloat toTitleBarAlpha;
    UIImageView *fromImageView;
    CGFloat fromRadius;
    UIImageView *toImageView;
    CGFloat toRadius;
    if (self.presentingVC) {
        detailViewController = (TraitDetailViewController *)toViewController;
        [containerView addSubview:detailViewController.view];

        detailViewController.traitDescriptionContainerView.transform = CGAffineTransformMakeTranslation(0, 300);
        detailViewController.aboutLabel.transform = CGAffineTransformMakeTranslation(0, 300);
        detailViewController.movieView.transform = CGAffineTransformMakeTranslation(0, 300);

        fromBackgroundFrame = viewFrame;
        toBackgroundFrame = detailViewController.scrollView.frame;

        fromTextSubviewsAlpha = 1;
        toTextSubviewsAlpha = 0;

        fromTitleBarAlpha = 0;
        toTitleBarAlpha = 1;

        fromImageView = self.imageView;
        fromRadius = self.imageView.layer.cornerRadius;
        toImageView = detailViewController.traitImageView;
        toRadius = kMaxAnimatingImageRadius;
    } else {
        // re-add for layering position
        detailViewController = (TraitDetailViewController *)fromViewController;
        [containerView addSubview:detailViewController.view];

        fromBackgroundFrame = detailViewController.scrollView.frame;
        toBackgroundFrame = viewFrame;

        fromTextSubviewsAlpha = 0;
        toTextSubviewsAlpha = 1;

        fromTitleBarAlpha = 1;
        toTitleBarAlpha = 0;

        fromImageView = detailViewController.traitImageView;
        fromRadius = kMaxAnimatingImageRadius;
        toImageView = self.imageView;
        toRadius = self.imageView.layer.cornerRadius;
    }

    animatingBackgroundView.frame = fromBackgroundFrame;
    viewWithOnlyTextSubviews.alpha = fromTextSubviewsAlpha;
    detailViewController.titleBar.alpha = fromTitleBarAlpha;
    detailViewController.view.backgroundColor = [UIColor clearColor];
    detailViewController.titleBar.backgroundColor = [UIColor clearColor];
    detailViewController.titleBarBackgroundHackView.backgroundColor = [UIColor clearColor];
    detailViewController.contentView.backgroundColor = [UIColor clearColor];

    // get the frames of fromImageView and toImageView in containerView's bounds
    CGRect fromImageViewFrame = [fromImageView convertRect:fromImageView.bounds toView:containerView];
    CGRect toImageViewFrame;
    // TODO(rajeev): this is hax, figure out why the rect isn't right
    if (self.presentingVC) {
        toImageViewFrame = CGRectMake(0, 70, 320, 224);
    } else {
        toImageViewFrame = [toImageView convertRect:toImageView.bounds toView:containerView];
    }

    CGRect fromFrame = CGRectMake(fromBackgroundFrame.origin.x, fromImageViewFrame.origin.y, fromBackgroundFrame.size.width, fromImageViewFrame.size.height);
    CGRect toFrame = CGRectMake(toBackgroundFrame.origin.x, toImageViewFrame.origin.y, toBackgroundFrame.size.width, toImageViewFrame.size.height);

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
    pathAnimation.duration = kZoomTransitionDuration;
    circleMask.path = toPath.CGPath;
    [animatingImageView.layer.mask addAnimation:pathAnimation forKey:@"path"];

    void (^completionHandler)(BOOL finished) = ^(BOOL finished) {
        fromImageView.alpha = 1;
        toImageView.alpha = 1;
        detailViewController.view.backgroundColor = UIColorFromHEX(CLColorDarkGrey);
        detailViewController.titleBar.backgroundColor = UIColorFromHEX(CLColorBackgroundBeige);
        detailViewController.titleBarBackgroundHackView.backgroundColor = UIColorFromHEX(CLColorBackgroundBeige);
        detailViewController.contentView.backgroundColor = UIColorFromHEX(CLColorBackgroundBeige);
        [animatingBackgroundView removeFromSuperview];
        [viewWithOnlyTextSubviews removeFromSuperview];
        [animatingImageView removeFromSuperview];
        [transitionContext completeTransition:YES];
    };

    // animate the actual views
    [UIView animateWithDuration:kZoomTransitionDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        animatingBackgroundView.frame = toBackgroundFrame;
        viewWithOnlyTextSubviews.alpha = toTextSubviewsAlpha;
        detailViewController.titleBar.alpha = toTitleBarAlpha;
        animatingImageView.frame = toFrame;
        fromViewController.view.alpha = 0;
        toViewController.view.alpha = 1;
    } completion:^(BOOL finished) {
        // no slide transitions during dismissal
        if (!self.presentingVC) {
            completionHandler(finished);
            return;
        }

        [UIView animateWithDuration:kSlide1TransitionDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            detailViewController.traitDescriptionContainerView.transform = CGAffineTransformMakeTranslation(0, 0);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:kSlide2TransitionDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                detailViewController.aboutLabel.transform = CGAffineTransformMakeTranslation(0, 0);
                detailViewController.movieView.transform = CGAffineTransformMakeTranslation(0, 0);
            } completion:completionHandler];
        }];
    }];
}

@end
