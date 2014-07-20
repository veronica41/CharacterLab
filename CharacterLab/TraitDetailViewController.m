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

static NSString *kTipCellIdentifier = @"TipCell";
static NSString *kStudentCellIdentifier = @"StudentsRankingCell";
static CGFloat kTipCellDefaultWidth = 280.0;
static CGFloat kTipsCollectionViewDefaultHeight = 154.0;
static CGFloat kStudentsCollectionViewDefaultWidth = 148.0;
static CGFloat kStudentsCollectionViewDefaultHeight = 154.0;
static NSInteger kDefaultNumOfStudents = 5;

@interface TraitDetailViewController ()

@property (weak, nonatomic) IBOutlet UIView *titleBar;
- (IBAction)onBackButton:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

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

    // setup navigation bar
//    self.navigationController.navigationBar.barTintColor = UIColorFromHEX(CLColorBackgroundBeige);
//    self.navigationController.navigationBar.tintColor = UIColorFromHEX(CLColorTextBrown);
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_navBackLight"] style:UIBarButtonItemStylePlain target:self action:@selector(onBackButton:)];
//    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: UIColorFromHEX(CLColorTextBrown), NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-Medium" size:20.0]};
//    self.navigationItem.title = self.trait.name;

    [self setupVideoPlayer];
    [self setupTipsCollectionView];
    [self setupStudentsCollectionView];

    self.titleLabel.text = self.trait.name;
    self.traitImageView.image = [UIImage imageNamed:self.trait.name];
    self.traitDescriptionLabel.text = self.trait.desc;
    self.aboutLabel.text = [NSString stringWithFormat:@"ABOUT %@", self.trait.name.uppercaseString];
    self.buildLabel.text = [NSString stringWithFormat:@"BUILD %@", self.trait.name.uppercaseString];
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
        [self collectionView:collectionView configureCell:cell atIndexPath:indexPath];
        return cell;
    } else if (collectionView == self.topStudentsCollectionView) {
        StudentsRankingCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kStudentCellIdentifier forIndexPath:indexPath];
        Assessment *assessment = self.topAssessments[indexPath.row];
        Student *student = self.studentAsessment[assessment.objectId];
        cell.initialsLabel.student = student;
        cell.nameLabel.text = student.name;
        return cell;
    } else if (collectionView == self.bottomStudentsCollectionView) {
        StudentsRankingCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kStudentCellIdentifier forIndexPath:indexPath];
        Assessment *assessment = self.bottomAssessments[indexPath.row];
        Student *student = self.studentAsessment[assessment.objectId];
        cell.initialsLabel.student = student;
        cell.nameLabel.text = student.name;
        return cell;
    }
    return nil;
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
    if (collectionView == self.tipsCollectionView) {
        NSIndexPath *prevExpanded = self.expandedIndexPath;

        if (!prevExpanded) {
            // expand collectionView
            self.expandedIndexPath = indexPath;
            TipCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kTipCellIdentifier forIndexPath:indexPath];
            [self collectionView:collectionView configureCell:cell atIndexPath:indexPath];
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

@end
