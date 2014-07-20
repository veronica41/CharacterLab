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

@interface StudentProfileViewController () <UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate, ImprovementSuggestionViewCellDelegate>

@property (weak, nonatomic) IBOutlet UIView *mainWrapperView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet StudentInitialsLabel *initialsLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastMeasurementTime;
@property (weak, nonatomic) IBOutlet UIView *initialsBackgroundView;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UITableView *measurementTable;
@property (weak, nonatomic) IBOutlet UICollectionView *improvementsCollection;

// Private support variables
@property (nonatomic, strong) NSArray *traitsToImprove;
@property (nonatomic, strong) NSArray *measurementList;
@property (nonatomic, strong) NSArray *latestAssessmentScores;
@property (nonatomic, strong) NSMutableDictionary *traitDescriptions;
@property (nonatomic, strong) Measurement *lastMeasurement;
@property (weak, nonatomic) BarGraphView *barGraphView;

- (IBAction)onBackButton:(UIButton *)sender;
- (IBAction)onMeasurePress:(UIButton *)sender;

@end

@implementation StudentProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.mainWrapperView.backgroundColor = [UIColor darkGrayColor];
    self.initialsBackgroundView.backgroundColor = UIColorFromHEX(CLColorDarkGray);
    
    self.nameLabel.font = [UIFont fontWithName:@"Avenir" size:20];
    self.initialsLabel.font = [UIFont fontWithName:@"Avenir" size:15];
    self.lastMeasurementTime.font = [UIFont fontWithName:@"Avenir" size:15];

    self.nameLabel.text = self.student.name;
    self.initialsLabel.student = self.student;
    self.lastMeasurementTime.text = self.student.lastAssessmentTS.timeAgoSinceNow;
    self.deleteButton.backgroundColor = UIColorFromHEX(CLColorBlastOffRed);
    self.deleteButton.layer.cornerRadius = 5;

    [self setupMeasurementsTable];
    [self setupImprovementsSuggestionsCollectionView];

    // setup barchart - the data points are fetched in the callbacks for the datasource
    BarGraphView *barGraphView = [[BarGraphView alloc] initWithFrame:CGRectMake(0, 140, self.view.frame.size.width, 200)];
    [self.view addSubview:barGraphView];

    CLModel *client = [CLModel sharedInstance];
    if (self.student.lastMeasurementID) {
        // store the last measurement object
        [client getLatestMeasurementForStudent:self.student success:^(Measurement *measurement) {
            self.lastMeasurement = measurement;
            // Pull data for traits that need improvement
            if (self.measurementList.count > 0) {
                [[CLModel sharedInstance] getAssessmentsForMeasurement:[self.measurementList objectAtIndex:0] success:^(NSArray *assessmentList) {
                    self.latestAssessmentScores = assessmentList;
                    [self updateBarChart];
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
    self.measurementTable.dataSource = self;
    self.measurementTable.backgroundColor = [UIColor clearColor];
    self.measurementTable.opaque = NO;
    UINib *cellNib = [UINib nibWithNibName:kMeasurementViewCell bundle:nil];
    [self.measurementTable registerNib:cellNib forCellReuseIdentifier:kMeasurementViewCell];
    [[CLModel sharedInstance] getMeasurementsForStudent:self.student success:^(NSArray *measurementList) {
        self.measurementList = measurementList;
        [self.measurementTable reloadData];
    } failure:^(NSError *error) {
        NSLog(@"Failure retrieving the measurements for %@", self.student);
    }];
}

- (void)setupImprovementsSuggestionsCollectionView {
    self.improvementsCollection.dataSource = self;
    self.improvementsCollection.delegate = self;

    // preallocate one custom view for the improvement suggestions
    UINib *tmpCellNib = [UINib nibWithNibName:kImprovementSuggestionViewCell bundle:nil];
    [self.improvementsCollection registerNib:tmpCellNib forCellWithReuseIdentifier:@"ImprovementSuggestionViewCell"];

    UINib *improvementSuggestionCellNib = [UINib nibWithNibName:kImprovementTraitCell bundle:nil];
    [self.improvementsCollection registerNib:improvementSuggestionCellNib forCellWithReuseIdentifier:kImprovementTraitCell];
    self.improvementsCollection.contentSize = CGSizeMake(320 * 4, 100);
}

- (void)updateBarChart {
    NSLog(@"PIER scores are %@", self.latestAssessmentScores);
}

#pragma mark - ImprovementSuggestionViewCellDelegate

- (void)updateSelectedSuggestionItem:(int)itemSelected {
    // scroll to the cell
    NSIndexPath *idx = [NSIndexPath indexPathForItem:itemSelected inSection:0];
    [self.improvementsCollection scrollToItemAtIndexPath:idx
                               atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                       animated:YES];

    // call delegate method
    [self collectionView:self.improvementsCollection cellForItemAtIndexPath:idx];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
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
        cell.pageNumLabel.text = [NSString stringWithFormat:@"%d/%ld", indexPath.item + 1, 1 + (unsigned long)self.traitsToImprove.count];
        return cell;
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
        cell.backgroundColor = UIColorFromHEX(CLColorDarkGray);
    }
    else {
        cell.backgroundColor = [UIColor blackColor];
    }
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onBackButton:(UIButton *)sender {
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onMeasurePress:(UIButton *)sender {
    AssessmentInputViewController *avc = [[AssessmentInputViewController alloc] init];
    avc.student = self.student;
    [self presentViewController:avc animated:YES completion:nil];
}

@end
