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
#import "StudentsRankingCell.h"
#import "TipCell.h"
#import "CLColor.h"
#import "CLModel.h"
#import "CollectionLayoutAlignTop.h"
#import "UIImageView+AFNetworking.h"

static NSString *kTipCellIdentifier = @"TipCell";
static NSString *kStudentCellIdentifier = @"StudentsRankingCell";
static CGFloat kTipCellDefaultWidth = 280.0;
static CGFloat kTipsCollectionViewDefaultHeight = 154.0;
static CGFloat kStudentsCollectionViewDefaultWidth = 132.0;
static CGFloat kStudentsCollectionViewDefaultHeight = 154.0;
static NSInteger kDefaultNumOfStudents = 5;

@interface TraitDetailViewController ()

- (IBAction)onBackButton:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *traitDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *buildLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *tipsCollectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tipsCollectionViewHeight;
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

    self.titleLabel.text = self.trait.name;
    self.traitImageView.image = [UIImage imageNamed:self.trait.name];
    self.traitDescriptionLabel.text = self.trait.desc;
    self.aboutLabel.text = [NSString stringWithFormat:@"ABOUT %@", self.trait.name.uppercaseString];
    self.buildLabel.text = [NSString stringWithFormat:@"BUILD %@", self.trait.name.uppercaseString];

    self.linkLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickLink:)];
    //[tapRecognizer setNumberOfTouchesRequired:1];
    [self.linkLabel addGestureRecognizer:tapRecognizer];
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

- (void)setupTipsCollectionView {
    self.expandedIndexPath = nil;
    self.tipsCollectionView.dataSource = self;
    self.tipsCollectionView.delegate = self;
    UINib *tipCellNib = [UINib nibWithNibName:kTipCellIdentifier bundle:nil];
    [self.tipsCollectionView registerNib:tipCellNib forCellWithReuseIdentifier:kTipCellIdentifier];
    
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
        return cell;
    }
    return nil;
}

// helper method
- (void)collectionView:(UICollectionView *)collectionView configureTipCell:(TipCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    Tip *tip = self.tips[indexPath.item];
    cell.summaryLabel.text = tip.summary;
    cell.descLabel.text = tip.desc;
    cell.pageNumLabel.text = [NSString stringWithFormat:@"%ld/%ld", indexPath.item+1, (unsigned long)self.tips.count];
}

- (void)collectionView:(UICollectionView *)collectionView configureStudentCell:(StudentsRankingCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.imageView.image = nil;
    Assessment *assessment;
    if (collectionView == self.topStudentsCollectionView) {
        assessment = self.topAssessments[indexPath.row];
    } else if (collectionView == self.bottomStudentsCollectionView) {
        assessment = self.bottomAssessments[indexPath.row];
    }
    Student *student = self.studentAsessment[assessment.objectId];
    [cell.imageView setImageWithURL:[NSURL URLWithString:student.photoUrl]];
    cell.nameLabel.text = student.name;
}


#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.tipsCollectionView) {
        NSIndexPath *prevExpanded = self.expandedIndexPath;

        if (!prevExpanded) {
            // expand collectionView
            self.expandedIndexPath = indexPath;
            TipCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kTipCellIdentifier forIndexPath:indexPath];
            [self collectionView:collectionView configureTipCell:cell atIndexPath:indexPath];
            [cell layoutIfNeeded];
            CGSize size = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
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
                                 [self.tipsCollectionView setNeedsLayout];
                             }];
        } else {
            // shrink previous selected cell, expand current selected cell
            self.expandedIndexPath = indexPath;
            [collectionView performBatchUpdates:nil completion:nil];
        }
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

# pragma mark - event handlers

- (IBAction)onBackButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onClickLink:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://www.characterlab.org"]];
}

@end
