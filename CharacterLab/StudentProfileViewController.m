//
//  StudentProfileViewController.m
//  CharacterLab
//
//  Created by Pierpaolo Baccichet on 7/6/14.
//  Copyright (c) 2014 Dropbox. All rights reserved.
//

#import "StudentProfileViewController.h"
#import "UIImageView+AFNetworking.h"
#import "UIColor+CharacterLab.h"

@interface StudentProfileViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) NSArray *assessmentScores;
@property (weak, nonatomic) IBOutlet UITableView *assessmentTable;
@property (strong, nonatomic) NSMutableDictionary *traitDescriptions;
@property (weak, nonatomic) IBOutlet UILabel *initialsLabel;

- (IBAction)onBackButton:(UIButton *)sender;

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
                // reload the data once we have the descriptions cached
                [self.assessmentTable reloadData];
            }
        } failure:^(NSError *error) {
            NSLog(@"Failure fetching traits");
        }];
    }
    return self;
}

// If the user is a new user and does not have any assessment, we need to create empty ones
- (void)fillEmptyAssessment
{
    for (Trait *trait in self.traitDescriptions) {
        Assessment *ass = [[Assessment alloc] init];
        ass.student = self.student;
        ass.trait = trait;
        ass.score = 0;
        [ass saveInBackground];
    }
}

/*
- (UIView *)getUserCircleWithFrame:(CGRect)rect color:(UIColor *)color text:(NSString *)text {

    UIView *view = [[UIView alloc] initWithFrame:rect];

    UIBezierPath *path = [UIBezierPath bezierPath];
    [path addArcWithCenter:CGPointMake(rect.size.width / 2, rect.size.height / 2)
                    radius:50.0
                startAngle:0.0
                  endAngle:2.0 * M_PI
                 clockwise:NO];
    [path fill];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextFillPath(context);

    // Add it do your label's layer hierarchy
    UILabel *label = [[UILabel alloc] initWithFrame:rect];
    label.text = text;
    label.textAlignment = NSTextAlignmentCenter;

    [label.layer addSublayer:circleLayer];
    return view;
}
 */

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

    self.view.backgroundColor = [UIColor CLBackgroundGrayColor];

    self.nameLabel.text = self.student.name;
    self.initialsLabel.text = [self getInitials:self.student.name];
    self.assessmentTable.delegate = self;
    self.assessmentTable.dataSource = self;

    [[CLModel sharedInstance] getAssessmentsForStudent:self.student success:^(NSArray *assessmentList) {
        self.assessmentScores = assessmentList;
        [self.assessmentTable reloadData];
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
@end
