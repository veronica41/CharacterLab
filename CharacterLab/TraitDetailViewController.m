//
//  TraitDetailViewController.m
//  CharacterLab
//
//  Created by Veronica Zheng on 7/7/14.
//  Copyright (c) 2014 Dropbox. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>
#import "YTVimeoExtractor.h"
#import "TraitDetailViewController.h"
#import "TipCell.h"
#import "CLColor.h"
#import "CLModel.h"
#import "CollectionLayoutAlignTop.h"

static NSString *kTipCellIdentifier = @"TipCell";
static CGFloat kTipCellDefaultWidth = 280.0;
static CGFloat kTipsCollectionViewDefaultHeight = 154.0;

@interface TraitDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *traitDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *aboutLabel;
@property (weak, nonatomic) IBOutlet UIView *movieView;
@property (weak, nonatomic) IBOutlet UILabel *buildLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *tipsCollectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tipsCollectionViewHeight;

@property (nonatomic, strong) YTVimeoExtractor *extrator;
@property (nonatomic, strong) MPMoviePlayerController *playerController;

@property (nonatomic, strong) NSArray *tips;
@property (nonatomic) NSIndexPath *expandedIndexPath;

@end


@implementation TraitDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // setup navigation bar
    self.navigationController.navigationBar.barTintColor = UIColorFromHEX(CLColorBackgroundBeige);
    self.navigationController.navigationBar.tintColor = UIColorFromHEX(CLColorTextBrown);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_navBackLight"] style:UIBarButtonItemStylePlain target:self action:@selector(onBackButton:)];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: UIColorFromHEX(CLColorTextBrown), NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-Medium" size:20.0]};
    self.navigationItem.title = self.trait.name;

    [self setupVideoPlayer];

    self.traitImageView.image = [UIImage imageNamed:self.trait.name];
    self.traitDescriptionLabel.text = self.trait.desc;
    self.aboutLabel.text = [NSString stringWithFormat:@"ABOUT %@", self.trait.name.uppercaseString];
    self.buildLabel.text = [NSString stringWithFormat:@"BUILD %@", self.trait.name.uppercaseString];

    if (self.hideImageViewOnLoad) {
        self.traitImageView.alpha = 0;
    }

    // setup tips collection view
    self.expandedIndexPath = nil;
    self.tipsCollectionView.dataSource = self;
    self.tipsCollectionView.delegate = self;
    UINib *tipCellNib = [UINib nibWithNibName:kTipCellIdentifier bundle:nil];
    [self.tipsCollectionView registerNib:tipCellNib forCellWithReuseIdentifier:kTipCellIdentifier];
   
    [[CLModel sharedInstance] getTipsForTrait:self.trait success:^(NSArray *tipsList) {
        self.tips = tipsList;
        [self.tipsCollectionView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"Failed to fetch tips, %@", error);
    }];
}

- (void)setupVideoPlayer {
    [YTVimeoExtractor fetchVideoURLFromURL:self.trait.videoUrl quality:YTVimeoVideoQualityLow completionHandler:^(NSURL *videoURL, NSError *error, YTVimeoVideoQuality quality) {
        if (error) {
            // TODO: (veronica) show video cannot be load
        } else {
            self.playerController = [[MPMoviePlayerController alloc] initWithContentURL:videoURL];
            self.playerController.shouldAutoplay = NO;
            [self.playerController prepareToPlay];
            self.playerController.view.frame = self.movieView.bounds;
            [self.movieView addSubview:self.playerController.view];
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.tips.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TipCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kTipCellIdentifier forIndexPath:indexPath];
    [self collectionView:collectionView configureCell:cell atIndexPath:indexPath];
    return cell;
}

// helper method
- (void)collectionView:(UICollectionView *)collectionView configureCell:(TipCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    Tip *tip = self.tips[indexPath.item];
    cell.summaryLabel.text = tip.summary;
    cell.descLabel.text = tip.desc;
    cell.pageNumLabel.text = [NSString stringWithFormat:@"%ld/%ld", indexPath.item+1, (unsigned long)self.tips.count];
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSIndexPath *prevExpanded = self.expandedIndexPath;

    if (!prevExpanded) {
        // expand collectionView
        self.expandedIndexPath = indexPath;
        TipCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kTipCellIdentifier forIndexPath:indexPath];
        [self collectionView:collectionView configureCell:cell atIndexPath:indexPath];
        [cell setNeedsLayout];
        CGSize size = [cell systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        if (size.height > kTipsCollectionViewDefaultHeight) {
            [UIView animateWithDuration: 0
                                  delay: 0
                                options: 0
                             animations:^{
                                 self.tipsCollectionViewHeight.constant = size.height;
                                 [self.tipsCollectionView setNeedsLayout];
                             } completion:^(BOOL finished){
                                 [collectionView performBatchUpdates:nil completion:nil];
                             }];
        }
    } else if (prevExpanded && prevExpanded.row == indexPath.item) {
        // shrink collectionView
        self.expandedIndexPath = nil;
        [UIView animateWithDuration: 0
                              delay: 0
                            options: 0
                         animations:^{
                             [collectionView performBatchUpdates:nil completion:nil];
                         } completion:^(BOOL finished){
                             self.tipsCollectionViewHeight.constant = kTipsCollectionViewDefaultHeight;
                         }];
    } else {
        // shrink previous selected cell, expand current selected cell
        self.expandedIndexPath = indexPath;
        [collectionView performBatchUpdates:nil completion:nil];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height;
    if (self.expandedIndexPath && indexPath.item == self.expandedIndexPath.item) {
        height = MAX(kTipsCollectionViewDefaultHeight, self.tipsCollectionView.contentSize.height);
        return  CGSizeMake(kTipCellDefaultWidth, height);
    }
    return CGSizeMake(kTipCellDefaultWidth, kTipsCollectionViewDefaultHeight);
}

# pragma mark - event handlers

- (void)onBackButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
