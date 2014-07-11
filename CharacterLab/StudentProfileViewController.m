//
//  StudentProfileViewController.m
//  CharacterLab
//
//  Created by Pierpaolo Baccichet on 7/6/14.
//  Copyright (c) 2014 Dropbox. All rights reserved.
//

#import "StudentProfileViewController.h"
#import "UIImageView+AFNetworking.h"
#import "Assessment.h"
#import "Trait.h"

@interface StudentProfileViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) NSArray *assessmentScores;
@property (weak, nonatomic) IBOutlet UITableView *assessmentTable;
@property (strong, nonatomic) NSMutableDictionary *traitDescriptions;

- (IBAction)onBackButton:(UIButton *)sender;

@end

@implementation StudentProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        // TODO PIER make sure these are cached in a global model
        self.traitDescriptions = [NSMutableDictionary dictionary];
        [[Trait query] findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            for (Trait *trait in objects) {
                self.traitDescriptions[trait.objectId] = trait.name;
                // reload the data once we have the descriptions cached
                [self.assessmentTable reloadData];
            }
        }];
    }
    return self;
}

// If the user is a new user and does not have any assessment, we need to create empty ones
- (void)fillEmptyAssessment
{
    [[Trait query] findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        for (Trait *trait in objects) {
            Assessment *ass = [[Assessment alloc] init];
            ass.student = self.student;
            ass.trait = trait;
            ass.score = 0;
            [ass saveInBackground];
        }
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.profileImage setImageWithURL:[NSURL URLWithString:self.student.photoUrl]];
    self.nameLabel.text = self.student.name;
    self.assessmentTable.delegate = self;
    self.assessmentTable.dataSource = self;

    PFQuery *query = [PFQuery queryWithClassName:@"Assessment"];
    [query whereKey:@"student" equalTo:self.student];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %d assessments.", objects.count);
            self.assessmentScores = objects;
            [self.assessmentTable reloadData];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@", error);
        }
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
