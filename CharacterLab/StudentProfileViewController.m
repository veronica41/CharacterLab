//
//  StudentProfileViewController.m
//  CharacterLab
//
//  Created by Pierpaolo Baccichet on 7/6/14.
//  Copyright (c) 2014 Dropbox. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "NSDate+DateTools.h"
#import "UIImageView+AFNetworking.h"

#import "CLColor.h"
#import "AssessmentInputViewController.h"
#import "MeasurementViewCell.h"
#import "ImprovementSuggestionViewCell.h"
#import "ImprovementTraitViewCell.h"
#import "StudentProfileViewController.h"
#import "StudentInitialsLabel.h"
#import "BarGraphView.h"

static NSString *kMeasurementViewCell = @"MeasurementViewCell";
static NSString *kImprovementTraitCell = @"ImprovementTraitViewCell";
static NSString *kImprovementSuggestionViewCell = @"ImprovementSuggestionViewCell";
static CGFloat kMeasurementTableRowHeight = 44;

@interface StudentProfileViewController () <UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate, ImprovementSuggestionViewCellDelegate>

@property (weak, nonatomic) IBOutlet UIView *titleBar;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet StudentInitialsLabel *initialsLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastMeasurementTime;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UITableView *measurementTable;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *measurementTableHeight;
@property (weak, nonatomic) IBOutlet UICollectionView *improvementsCollection;
@property (weak, nonatomic) IBOutlet UIScrollView *improvementsDummyScrollView;
@property (weak, nonatomic) IBOutlet BarGraphView *chartView;

// Private support variables
@property (nonatomic, strong) NSArray *traitsToImprove;
@property (nonatomic, strong) NSArray *measurementList;
@property (nonatomic, strong) NSArray *latestAssessmentList;
@property (nonatomic, strong) NSMutableDictionary *traitDescriptions;
@property (nonatomic, strong) Measurement *lastMeasurement;
@property (nonatomic) BOOL barGraphRendered;

- (IBAction)onBackButton:(UIButton *)sender;
- (IBAction)onMeasurePress:(UIButton *)sender;
- (IBAction)onMeasurementButton:(UIButton *)sender;

@end

@implementation StudentProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.traitDescriptions = [NSMutableDictionary dictionary];
        CLModel *client = [CLModel sharedInstance];
        [client getTraitsWitSuccess:^(NSArray *traitList) {
            for (Trait *trait in traitList) {
                self.traitDescriptions[trait.objectId] = trait.name;
            }
        } failure:^(NSError *error) {
            NSLog(@"Failure fetching traits");
        }];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    if (self.barGraphRendered) {
        CLModel *client = [CLModel sharedInstance];
        // store the last measurement object
        [client getLatestMeasurementForStudent:self.student success:^(Measurement *measurement) {
            self.lastMeasurement = measurement;
            // Pull data for traits that need improvement
            if (self.lastMeasurement) {
                [[CLModel sharedInstance] getAssessmentsForMeasurement:self.lastMeasurement success:^(NSArray *assessmentList) {
                    self.latestAssessmentList = assessmentList;
                    [self.chartView drawGraphWithAnimation:NO assessmentList:self.latestAssessmentList];
                    [client getLowestScoringTraitsForAssessment:assessmentList limit:3 success:^(NSArray *traitList) {
                        self.traitsToImprove = traitList;
                        [self.improvementsCollection reloadData];
                    } failure:^(NSError *error) {
                        NSLog(@"Failed to fetch traits that need improvements");
                    }];
                } failure:^(NSError *error) {
                    NSLog(@"Failure retrieving the assessments for %@", self.student);
                }];
            }
        } failure:^(NSError *error) {
            NSLog(@"Error fetching last measurement: %@", error);
        }];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.nameLabel.text = self.student.name;
    self.initialsLabel.student = self.student;
    self.lastMeasurementTime.text = self.student.lastAssessmentTS.timeAgoSinceNow;
    self.deleteButton.backgroundColor = UIColorFromHEX(CLColorBlastOffRed);
    self.deleteButton.layer.cornerRadius = 5;

    self.titleBar.layer.shadowColor = [UIColorFromHEX(CLColorShadowGrey) CGColor];

    CALayer *titleBarBorder = [CALayer layer];
    titleBarBorder.frame = CGRectMake(0, self.titleBar.frame.size.height, self.titleBar.frame.size.width, 0.5);
    titleBarBorder.backgroundColor = [UIColorFromHEX(CLColorDarkGrey) CGColor];
    titleBarBorder.opacity = 1;
    [self.titleBar.layer addSublayer:titleBarBorder];

    CAShapeLayer* innerShadowLayer = [CAShapeLayer layer];
    innerShadowLayer.frame = CGRectMake(0, 0.3, self.titleBar.bounds.size.width, 10);
    innerShadowLayer.backgroundColor = [UIColorFromHEX(CLColorBackgroundGrey) CGColor];
    innerShadowLayer.cornerRadius = 10;
    innerShadowLayer.shadowRadius = 0;
    innerShadowLayer.shadowColor = [[UIColor whiteColor] CGColor];
    innerShadowLayer.shadowOpacity = 0.1;
    innerShadowLayer.shadowOffset = CGSizeMake(0, -0.3);
    [self.titleBar.layer addSublayer:innerShadowLayer];

    self.chartView.hidden = YES;
    [self setupMeasurementsTable];
    [self setupImprovementsSuggestionsCollectionView];

    CLModel *client = [CLModel sharedInstance];
    self.barGraphRendered = NO;
    if (self.student.lastMeasurementID) {
        // store the last measurement object
        [client getLatestMeasurementForStudent:self.student success:^(Measurement *measurement) {
            self.lastMeasurement = measurement;
            // Pull data for traits that need improvement
            if (self.lastMeasurement) {
                [[CLModel sharedInstance] getAssessmentsForMeasurement:self.lastMeasurement success:^(NSArray *assessmentList) {
                    self.latestAssessmentList = assessmentList;
                    if (!self.barGraphRendered) {
                        self.barGraphRendered = YES;
                        self.chartView.hidden = NO;
                        [self.chartView drawGraphWithAnimation:YES assessmentList:self.latestAssessmentList];
                    }
                    [client getLowestScoringTraitsForAssessment:assessmentList limit:3 success:^(NSArray *traitList) {
                        self.traitsToImprove = traitList;
                        [self.improvementsCollection reloadData];
                    } failure:^(NSError *error) {
                        NSLog(@"Failed to fetch traits that need improvements");
                    }];
                } failure:^(NSError *error) {
                    NSLog(@"Failure retrieving the assessments for %@", self.student);
                }];
            }
        } failure:^(NSError *error) {
            NSLog(@"Error fetching last measurement: %@", error);
        }];
    }
}

- (void)setupMeasurementsTable {
    self.measurementTable.layer.cornerRadius = 5.0;
    self.measurementTable.dataSource = self;
    UINib *cellNib = [UINib nibWithNibName:kMeasurementViewCell bundle:nil];
    [self.measurementTable registerNib:cellNib forCellReuseIdentifier:kMeasurementViewCell];
    [[CLModel sharedInstance] getMeasurementsForStudent:self.student success:^(NSArray *measurementList) {
        self.measurementList = measurementList;
        self.measurementTableHeight.constant = self.measurementList.count * kMeasurementTableRowHeight;
        [self.measurementTable reloadData];
    } failure:^(NSError *error) {
        NSLog(@"Failure retrieving the measurements for %@", self.student);
    }];
}

- (void)setupImprovementsSuggestionsCollectionView {
    self.improvementsCollection.dataSource = self;
    self.improvementsCollection.delegate = self;
    self.improvementsDummyScrollView.delegate = self;

    [self.improvementsCollection addGestureRecognizer:self.improvementsDummyScrollView.panGestureRecognizer];
    self.improvementsCollection.panGestureRecognizer.enabled = NO;

    // preallocate one custom view for the improvement suggestions
    UINib *tmpCellNib = [UINib nibWithNibName:kImprovementSuggestionViewCell bundle:nil];
    [self.improvementsCollection registerNib:tmpCellNib forCellWithReuseIdentifier:@"ImprovementSuggestionViewCell"];

    UINib *improvementSuggestionCellNib = [UINib nibWithNibName:kImprovementTraitCell bundle:nil];
    [self.improvementsCollection registerNib:improvementSuggestionCellNib forCellWithReuseIdentifier:kImprovementTraitCell];
}

#pragma mark - ImprovementSuggestionViewCellDelegate

- (void)updateSelectedSuggestionItem:(int)itemSelected {
    // scroll to the cell
    NSIndexPath *idx = [NSIndexPath indexPathForItem:itemSelected inSection:0];
    [self.improvementsDummyScrollView scrollRectToVisible:CGRectMake(self.improvementsDummyScrollView.frame.size.width * idx.row, 0, self.improvementsDummyScrollView.frame.size.width, self.improvementsDummyScrollView.frame.size.height) animated:YES];

    // call delegate method
    [self collectionView:self.improvementsCollection cellForItemAtIndexPath:idx];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    self.improvementsDummyScrollView.contentSize = CGSizeMake(self.improvementsDummyScrollView.frame.size.width * (self.traitsToImprove.count + 1), self.improvementsDummyScrollView.frame.size.height);
    return self.traitsToImprove.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item == 0)
    {
        // first collection shows the suggestions
        ImprovementSuggestionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kImprovementSuggestionViewCell forIndexPath:indexPath];
        Trait *trait = [self.traitsToImprove objectAtIndex:0];
        cell.traitLabel1.text = trait.name;
        cell.traitImage1.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@Circle", [trait.name lowercaseString]]];

        trait = [self.traitsToImprove objectAtIndex:1];
        cell.traitLabel2.text = trait.name;
        cell.traitImage2.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@Circle", [trait.name lowercaseString]]];

        trait = [self.traitsToImprove objectAtIndex:2];
        cell.traitLabel3.text = trait.name;
        cell.traitImage3.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@Circle", [trait.name lowercaseString]]];
        cell.pageNumLabel.text = [NSString stringWithFormat:@"1/%ld", 1 + (unsigned long)self.traitsToImprove.count];

        cell.delegate = self;

        // call setup after setting the images on image view
        [cell setup];

        return cell;
    }
    else
    {
        Trait *trait = [self.traitsToImprove objectAtIndex:indexPath.item - 1];
        ImprovementTraitViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kImprovementTraitCell forIndexPath:indexPath];
        cell.titleLabel.text = [NSString stringWithFormat:@"Improve %@", trait.name];
        cell.suggestion1Label.text = trait.suggestion1;
        cell.suggestion2Label.text = trait.suggestion2;
        cell.suggestion3Label.text = trait.suggestion3;
        cell.pageNumLabel.text = [NSString stringWithFormat:@"%ld/%ld", indexPath.item + 1, 1 + (unsigned long)self.traitsToImprove.count];
        return cell;
    }
}

#pragma mark - UICollectionViewDelegate

- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.improvementsDummyScrollView) {
        // reflect the scroll position of the dummy scroll view in the collection view
        CGPoint contentOffset = scrollView.contentOffset;
        contentOffset.x = contentOffset.x - self.improvementsCollection.contentInset.left;
        self.improvementsCollection.contentOffset = contentOffset;
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.measurementList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSDateFormatter *dateFormatter = nil;
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    }

    MeasurementViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kMeasurementViewCell forIndexPath:indexPath];
    Measurement *measurement = [self.measurementList objectAtIndex:indexPath.row];
    cell.titleLabel.text = [NSString stringWithString:measurement.title];
    cell.dateLabel.text = [dateFormatter stringFromDate:measurement.createdAt];
    if (indexPath.row % 2 == 0) {
        cell.backgroundColor = UIColorFromHEX(CLColorShadowGrey);
    }
    else {
        cell.backgroundColor = UIColorFromHEX(CLColorDarkGrey);
    }
    return cell;
}

- (IBAction)onBackButton:(UIButton *)sender {
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onMeasurePress:(UIButton *)sender {
    [self onMeasureShare];
}

- (IBAction)onMeasurementButton:(UIButton *)sender {
    [self onMeasureShare];
}

- (IBAction)onMeasurementTap:(UITapGestureRecognizer *)sender {
    [self onMeasureShare];
}

- (void)onMeasureShare {
    AssessmentInputViewController *avc = [[AssessmentInputViewController alloc] init];
    avc.student = self.student;
    [self presentViewController:avc animated:YES completion:nil];
}

@end
