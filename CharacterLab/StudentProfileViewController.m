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
#import "StudentProfileViewController.h"
#import "StudentInitialsLabel.h"

@interface StudentProfileViewController () <UITableViewDataSource, UITableViewDelegate>

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
        [[CLModel sharedInstance] getTraitsWitSuccess:^(NSArray *traitList) {
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

    self.view.backgroundColor = UIColorFromHEX(CLColorGray);
    self.mainWrapperView.backgroundColor = UIColorFromHEX(CLColorGray);
    self.initialsBackgroundView.backgroundColor = UIColorFromHEX(CLColorDarkGray);

    self.nameLabel.text = self.student.name;
    self.initialsLabel.student = self.student;
    self.lastMeasurementTime.text = self.student.lastAssessmentTS.timeAgoSinceNow;
    self.deleteButton.backgroundColor = UIColorFromHEX(CLColorBlastOffRed);
    self.deleteButton.layer.cornerRadius = 5;

    self.measurementTable.delegate = self;
    self.measurementTable.dataSource = self;
    UINib *cellNib = [UINib nibWithNibName:@"measurementCell" bundle:nil];
    [self.measurementTable registerNib:cellNib forCellReuseIdentifier:@"measurementCell"];

    CLModel *client = [CLModel sharedInstance];
    [client getMeasurementsForStudent:self.student success:^(NSArray *measurementList) {
        self.measurementList = measurementList;

        if (self.measurementList.count > 0) {
            [client getAssessmentsForMeasurement:[self.measurementList objectAtIndex:0] success:^(NSArray *assessmentList) {
                self.LatestAssessmentScores = assessmentList;
            } failure:^(NSError *error) {
                NSLog(@"Failure retrieving the assessments for %@", self.student);
            }];
        }
    } failure:^(NSError *error) {
        NSLog(@"Failure retrieving the measurements for %@", self.student);
    }];
}

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

    MeasurementViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"measurementCell" forIndexPath:indexPath];
    Measurement *measurement = [self.measurementList objectAtIndex:indexPath.row];
    cell.descriptionLabel.text = measurement.description;
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
