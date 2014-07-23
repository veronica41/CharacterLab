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
#import "StudentProfileViewController.h"
#import "TipCell.h"
#import "CLColor.h"
#import "CLModel.h"
#import "CollectionLayoutAlignTop.h"
#import "UIImageView+AFNetworking.h"

static NSString *kTipCellIdentifier = @"TipCell";
static NSString *kStudentCellIdentifier = @"StudentsRankingCell";
static CGFloat kTipCellDefaultWidth = 280.0;
static CGFloat kTipsCollectionViewDefaultHeight = 154.0;
static CGFloat kStudentsCollectionViewDefaultWidth = 80.0;
static CGFloat kStudentsCollectionViewDefaultHeight = 103.0;
static NSInteger kDefaultNumOfStudents = 5;

@interface TraitDetailViewController ()

- (IBAction)onBackButton:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *traitDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *buildLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *tipsCollectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tipsCollectionViewHeight;
@property (weak, nonatomic) IBOutlet UIScrollView *tipsDummyScrollView;
@property (weak, nonatomic) IBOutlet UILabel *linkLabel;

@property (nonatomic, strong) YTVimeoExtractor *extrator;
@property (nonatomic, strong) MPMoviePlayerController *playerController;

@property (nonatomic, strong) NSArray *tips;
@property (nonatomic) NSIndexPath *expandedIndexPath;

@property (weak, nonatomic) IBOutlet UICollectionView *topStudentsCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *bottomStudentsCollectionView;
@property (nonatomic, strong) NSArray *topAssessments;
@property (nonatomic, strong) NSArray *bottomAssessments;
@property (nonatomic, strong) NSMutableDictionary *studentAsessment;

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

    [self setupVideoPlayer];
    [self setupTipsCollectionView];
    [self setupStudentsCollectionView];

    self.titleBarBorder = [CALayer layer];
    self.titleBarBorder.frame = CGRectMake(0, self.titleBar.frame.size.height, self.titleBar.frame.size.width, 0.5);
    self.titleBarBorder.backgroundColor = [UIColorFromHEX(CLColorTextBrown) CGColor];
    self.titleBarBorder.opacity = 0.5;
    [self.titleBar.layer addSublayer:self.titleBarBorder];

    self.titleLabel.text = self.trait.name;
    self.traitImageView.image = [UIImage imageNamed:self.trait.name];
    self.traitDescriptionLabel.text = self.trait.desc;
    self.aboutLabel.text = [NSString stringWithFormat:@"ABOUT %@", self.trait.name.uppercaseString];
    self.buildLabel.text = [NSString stringWithFormat:@"BUILD %@", self.trait.name.uppercaseString];

    self.linkLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickLink:)];
    [self.linkLabel addGestureRecognizer:tapRecognizer];
}

- (void)setupVideoPlayer {
    [YTVimeoExtractor fetchVideoURLFromURL:self.trait.videoUrl quality:YTVimeoVideoQualityLow completionHandler:^(NSURL *videoURL, NSError *error, YTVimeoVideoQuality quality) {
        if (error) {
            NSLog(@"Fetch video url error: %@", error);
        } else {
            self.playerController = [[MPMoviePlayerController alloc] initWithContentURL:videoURL];
            self.playerController.shouldAutoplay = NO;
            [self.playerController prepareToPlay];
            self.playerController.view.frame = self.movieView.bounds;
            [self.movieView addSubview:self.playerController.view];
        }
    }];
}

- (void)setupTipsCollectionView {
    self.expandedIndexPath = nil;
    self.tipsCollectionView.dataSource = self;
    self.tipsCollectionView.delegate = self;
    UINib *tipCellNib = [UINib nibWithNibName:kTipCellIdentifier bundle:nil];
    [self.tipsCollectionView registerNib:tipCellNib forCellWithReuseIdentifier:kTipCellIdentifier];
    self.tipsDummyScrollView.delegate = self;

    [self.tipsCollectionView addGestureRecognizer:self.tipsDummyScrollView.panGestureRecognizer];
    self.tipsCollectionView.panGestureRecognizer.enabled = NO;
    
    [[CLModel sharedInstance] getTipsForTrait:self.trait success:^(NSArray *tipsList) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.tips = tipsList;
            [self.tipsCollectionView reloadData];
        });
    } failure:^(NSError *error) {
        NSLog(@"Failed to fetch tips, %@", error);
    }];
}

- (void)setupStudentsCollectionView {
    self.topStudentsCollectionView.dataSource = self;
    self.topStudentsCollectionView.delegate = self;
    self.bottomStudentsCollectionView.dataSource = self;
    self.bottomStudentsCollectionView.delegate = self;
    UINib *studentCellNib = [UINib nibWithNibName:kStudentCellIdentifier bundle:nil];
    [self.topStudentsCollectionView registerNib:studentCellNib forCellWithReuseIdentifier:kStudentCellIdentifier];
    [self.bottomStudentsCollectionView registerNib:studentCellNib forCellWithReuseIdentifier:kStudentCellIdentifier];

    self.studentAsessment = [[NSMutableDictionary alloc] init];
    __block NSMutableArray *assessments = [[NSMutableArray alloc] init];
    [[CLModel sharedInstance] getStudentsForCurrentTeacherWithSuccess:^(NSArray *studentList) {
        [studentList enumerateObjectsUsingBlock:^(Student * student, NSUInteger idx, BOOL *stop) {
            [[CLModel sharedInstance] getLatestMeasurementForStudent:student success:^(Measurement *measurement) {

                if (measurement) {
                    [[CLModel sharedInstance] getAssessmentForMeasurement:measurement trait:self.trait success:^(Assessment *assessment) {
                        if (assessment) {
                            [assessments addObject:assessment];
                            self.studentAsessment[assessment.objectId] = student;
                            if (assessments.count == studentList.count) {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    NSMutableArray *orderedArray = [NSMutableArray arrayWithArray:assessments];
                                    [orderedArray sortUsingComparator:^NSComparisonResult(id a, id b) {
                                        NSInteger first = ((Assessment*)a).score;
                                        NSInteger second = ((Assessment*)b).score;
                                        return second < first;
                                    }];
                                    NSInteger numOfStudents = MIN(kDefaultNumOfStudents, orderedArray.count);
                                    self.bottomAssessments = [orderedArray subarrayWithRange:NSMakeRange(0, numOfStudents)];
                                    self.topAssessments = [orderedArray subarrayWithRange:NSMakeRange(orderedArray.count-numOfStudents, numOfStudents)];
                                    [self.topStudentsCollectionView reloadData];
                                    [self.bottomStudentsCollectionView reloadData];
                                });
                            }
                        }
                    } failure:^(NSError *error) {
                        NSLog(@"Error getting assessment: %@", error);
                    }];
                }

            } failure:^(NSError *error) {
                NSLog(@"Error: %@", error);
            }];
        }];
    } failure:^(NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == self.tipsCollectionView) {
        self.tipsDummyScrollView.contentSize = CGSizeMake(self.tipsDummyScrollView.frame.size.width * self.tips.count, self.tipsDummyScrollView.frame.size.height);
        return self.tips.count;
    } else if (collectionView == self.topStudentsCollectionView) {
        return self.topAssessments.count;
    } else if (collectionView == self.bottomStudentsCollectionView) {
        return self.bottomAssessments.count;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.tipsCollectionView) {
        TipCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kTipCellIdentifier forIndexPath:indexPath];
        [self collectionView:collectionView configureTipCell:cell atIndexPath:indexPath];
        return cell;
    } else if (collectionView == self.topStudentsCollectionView ||
               collectionView == self.bottomStudentsCollectionView) {
        StudentsRankingCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kStudentCellIdentifier forIndexPath:indexPath];
        [self collectionView:collectionView configureStudentCell:cell atIndexPath:indexPath];
        cell.delegate = self;
        return cell;
    }
    return nil;
}

// helper method
- (void)collectionView:(UICollectionView *)collectionView configureTipCell:(TipCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    Tip *tip = self.tips[indexPath.item];
    cell.summaryLabel.text = tip.summary;
    cell.descLabel.text = tip.desc;
    cell.pageNumLabel.text = [NSString stringWithFormat:@"%d/%ld", indexPath.item+1, (unsigned long)self.tips.count];
}

- (void)collectionView:(UICollectionView *)collectionView configureStudentCell:(StudentsRankingCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    Assessment *assessment;
    if (collectionView == self.topStudentsCollectionView) {
        assessment = self.topAssessments[indexPath.item];
    } else if (collectionView == self.bottomStudentsCollectionView) {
        assessment = self.bottomAssessments[indexPath.item];
    }
    Student *student = self.studentAsessment[assessment.objectId];
    [cell setStudent:student];
}

#pragma mark - UICollectionViewDelegate

// helper methods
- (void)shrinkExpandedItemInCollectionView:(UICollectionView *)collectionView completion:(void (^)(void))completion {
    if (collectionView == self.tipsCollectionView) {
        self.expandedIndexPath = nil;
        [self.tipsCollectionView performBatchUpdates:nil completion:^(BOOL finished) {
            if (completion) {
                completion();
            } else {
                [UIView animateWithDuration:500 animations:^{
                    self.tipsCollectionViewHeight.constant = kTipsCollectionViewDefaultHeight;
                    [self.view updateConstraints];
                }];
            }
        }];
    }
}

- (void)collectionView:(UICollectionView *)collectionView expandSelectedItemAtIndexPath:(NSIndexPath *)indexPath {
    self.expandedIndexPath = indexPath;

    // calculate cell height
    TipCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kTipCellIdentifier forIndexPath:indexPath];
    [self collectionView:collectionView configureTipCell:cell atIndexPath:indexPath];
    CGFloat height = cell.contentHeight;

    if (height > kTipsCollectionViewDefaultHeight) {
        [UIView animateWithDuration: 0
                              delay: 0
                            options: 0
                         animations:^{
                             self.tipsCollectionViewHeight.constant = height;
                             [self.tipsCollectionView setNeedsLayout];
                         } completion:^(BOOL finished){
                             [collectionView performBatchUpdates:nil completion:nil];
                         }];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.tipsCollectionView) {
        NSIndexPath *prevExpanded = self.expandedIndexPath;

        if (prevExpanded && prevExpanded.item == indexPath.item) {
            [self shrinkExpandedItemInCollectionView:collectionView completion:nil];
        } else {
            [self shrinkExpandedItemInCollectionView:self.tipsCollectionView completion:^{
                [self collectionView:collectionView expandSelectedItemAtIndexPath:indexPath];
                 [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
            }];
        }
       
    }
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tipsDummyScrollView) {
        // reflect the scroll position of the dummy scroll view in the collection view
        CGPoint contentOffset = scrollView.contentOffset;
        contentOffset.x = contentOffset.x - self.tipsCollectionView.contentInset.left;
        self.tipsCollectionView.contentOffset = contentOffset;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView == self.tipsDummyScrollView) {
        [self shrinkExpandedItemInCollectionView:self.tipsCollectionView completion:nil];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.tipsCollectionView) {
        CGFloat height;
        if (self.expandedIndexPath && indexPath.item == self.expandedIndexPath.item) {
            height = MAX(kTipsCollectionViewDefaultHeight, self.tipsCollectionViewHeight.constant);
            return  CGSizeMake(kTipCellDefaultWidth, height);
        }
        return CGSizeMake(kTipCellDefaultWidth, kTipsCollectionViewDefaultHeight);
    } else if (collectionView == self.topStudentsCollectionView || collectionView == self.bottomStudentsCollectionView) {
        return CGSizeMake(kStudentsCollectionViewDefaultWidth, kStudentsCollectionViewDefaultHeight);
    }
    return CGSizeZero;
}

# pragma mark - StudentsRankingCellDelegate

- (void)studentOnTap:(Student *)student {
    StudentProfileViewController *spvc = [[StudentProfileViewController alloc] init];
    spvc.student = student;
    [self presentViewController:spvc animated:YES completion:nil];
}

# pragma mark - event handlers

- (IBAction)onBackButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onClickLink:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://www.characterlab.org"]];
}

@end
