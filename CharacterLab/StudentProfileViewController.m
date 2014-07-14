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
#import "StudentProfileViewController.h"
#import "StudentInitialsLabel.h"

@interface StudentProfileViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) NSArray *assessmentScores;
@property (strong, nonatomic) NSMutableDictionary *traitDescriptions;
@property (weak, nonatomic) IBOutlet StudentInitialsLabel *initialsLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastMeasurementTime;
@property (weak, nonatomic) IBOutlet UIView *initialsBackgroundView;

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
    self.initialsBackgroundView.backgroundColor = UIColorFromHEX(CLColorDarkGray);

    self.nameLabel.text = self.student.name;
    self.initialsLabel.student = self.student;
    self.initialsLabel.backgroundColor = [self.student getColorForIcon];
    self.lastMeasurementTime.text = self.student.lastAssessmentTS.timeAgoSinceNow;

    [[CLModel sharedInstance] getAssessmentsForStudent:self.student success:^(NSArray *assessmentList) {
        self.assessmentScores = assessmentList;
    } failure:^(NSError *error) {
        NSLog(@"Failure retrieving the assessments for %@", self.student);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.assessmentScores count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"assessmentCell"];
    Trait *trait = self.assessmentScores[indexPath.row][@"trait"];
    cell.textLabel.text = [NSString stringWithFormat:@"%@: %@", self.traitDescriptions[trait.objectId], self.assessmentScores[indexPath.row][@"score"]];
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
