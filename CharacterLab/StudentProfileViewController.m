//
//  StudentProfileViewController.m
//  CharacterLab
//
//  Created by Pierpaolo Baccichet on 7/6/14.
//  Copyright (c) 2014 Dropbox. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <CorePlot-CocoaTouch.h>

#import "NSDate+DateTools.h"
#import "UIImageView+AFNetworking.h"

#import "CLColor.h"
#import "AssessmentInputViewController.h"
#import "MeasurementViewCell.h"
#import "ImprovementSuggestionViewCell.h"
#import "ImprovementTraitViewCell.h"
#import "StudentProfileViewController.h"
#import "StudentInitialsLabel.h"

static NSString *kMeasurementViewCell = @"MeasurementViewCell";
static NSString *kImprovementTraitCell = @"ImprovementTraitViewCell";
static NSString *kImprovementSuggestionViewCell = @"ImprovementSuggestionViewCell";

@interface StudentProfileViewController () <UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *mainWrapperView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) NSArray *LatestAssessmentScores;
@property (strong, nonatomic) NSMutableDictionary *traitDescriptions;
@property (weak, nonatomic) IBOutlet StudentInitialsLabel *initialsLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastMeasurementTime;
@property (weak, nonatomic) IBOutlet UIView *initialsBackgroundView;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UITableView *measurementTable;
@property (nonatomic, strong) NSArray *measurementList;
@property (nonatomic, strong) Measurement *lastMeasurement;
@property (weak, nonatomic) IBOutlet UICollectionView *improvementsCollection;
@property (strong, nonatomic) NSArray *traitsToImprove;

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

    self.nameLabel.text = self.student.name;
    self.initialsLabel.student = self.student;
    self.lastMeasurementTime.text = self.student.lastAssessmentTS.timeAgoSinceNow;
    self.deleteButton.backgroundColor = UIColorFromHEX(CLColorBlastOffRed);
    self.deleteButton.layer.cornerRadius = 5;

    [self setupMeasurementsTable];
    [self setupImprovementsSuggestionsCollectionView];

    CLModel *client = [CLModel sharedInstance];
    if (self.student.lastMeasurementID) {
        // store the last measurement object
        [client getLatestMeasurementForStudent:self.student success:^(Measurement *measurement) {
            self.lastMeasurement = measurement;
            // Pull data for traits that need improvement
            if (self.measurementList.count > 0) {
                [[CLModel sharedInstance] getAssessmentsForMeasurement:[self.measurementList objectAtIndex:0] success:^(NSArray *assessmentList) {
                    self.LatestAssessmentScores = assessmentList;
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
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.traitsToImprove.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item == 1)
    {
        // first collection shows the suggestions
        ImprovementSuggestionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kImprovementSuggestionViewCell forIndexPath:indexPath];
        cell.trait1 = [self.traitsToImprove objectAtIndex:0];
        cell.trait2 = [self.traitsToImprove objectAtIndex:1];
        cell.trait3 = [self.traitsToImprove objectAtIndex:2];
        cell.pageNumLabel.text = [NSString stringWithFormat:@"1/%ld", 1 + (unsigned long)self.traitsToImprove.count];
        return cell;
    }
    else
    {
        Trait *trait = [self.traitsToImprove objectAtIndex:indexPath.item - 2];
        ImprovementTraitViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kImprovementTraitCell forIndexPath:indexPath];
        cell.suggestion1 = [NSString stringWithFormat:@"%@ suggestion 1", trait.name];
        cell.suggestion2 = [NSString stringWithFormat:@"%@ suggestion 2", trait.name];
        cell.suggestion3 = [NSString stringWithFormat:@"%@ suggestion 3", trait.name];
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
