//
//  StudentProfileViewController.m
//  CharacterLab
//
//  Created by Pierpaolo Baccichet on 7/6/14.
//  Copyright (c) 2014 Dropbox. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "CLColor.h"
#import "AssessmentInputViewController.h"
#import "StudentProfileViewController.h"
#import "UIImageView+AFNetworking.h"


@interface StudentProfileViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) NSArray *assessmentScores;
@property (strong, nonatomic) NSMutableDictionary *traitDescriptions;
@property (weak, nonatomic) IBOutlet UILabel *initialsLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastMeasurementTime;
@property (weak, nonatomic) IBOutlet UIView *initialsBackgroundView;

- (IBAction)onBackButton:(UIButton *)sender;
- (IBAction)onMeasurePress:(UIButton *)sender;

- (NSString *)getInitials:(NSString *)name;

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

- (NSString *)getInitials:(NSString *)name {
    NSArray *nameComponents = [self.student.name componentsSeparatedByString: @" "];
    int cnt = [nameComponents count];
    NSMutableString *ret_val = [@"" mutableCopy];

    if (cnt > 0) {
        [ret_val appendFormat:@"%c", [nameComponents[0] characterAtIndex:0]];
        if (cnt > 1) {
            [ret_val appendFormat:@"%c", [nameComponents[1] characterAtIndex:0]];
        }
    }
    return [ret_val uppercaseString];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = UIColorFromHEX(CLColorGray);
    self.initialsBackgroundView.backgroundColor = UIColorFromHEX(CLColorDarkGray);

    self.nameLabel.text = self.student.name;
    self.initialsLabel.text = [self getInitials:self.student.name];
    self.initialsLabel.layer.cornerRadius = self.initialsLabel.frame.size.width / 2;

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
    [self presentViewController:avc animated:YES completion:nil];
}
@end
