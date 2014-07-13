//
//  AssessmentInputViewController.m
//  CharacterLab
//
//  Created by Pierpaolo Baccichet on 7/12/14.
//  Copyright (c) 2014 Dropbox. All rights reserved.
//

#import "MBProgressHUD.h"

#import "AssessmentInputViewController.h"
#import "NewAssessmentViewCell.h"
#import "CLColor.h"

@interface AssessmentInputViewController () <UITableViewDataSource, UITableViewDelegate, NewAssessmentViewCellDelegate>

@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *assessmentValues;

@property (nonatomic, strong) NSMutableArray *traitObjects;

- (IBAction)onCancel:(UIButton *)sender;
- (IBAction)onDone:(UIButton *)sender;

@end

@implementation AssessmentInputViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.assessmentValues = [NSMutableArray array];
        for (int traitID = 0 ; traitID < CLTraitMAX ; traitID++) {
            self.assessmentValues[traitID] = @(6); // default mid-way
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.nameLabel.text = self.student.name;
    // Need to store the objects corresponding to traits for later
    [[CLModel sharedInstance] getTraitsWitSuccess:^(NSArray *traitList) {
        self.traitObjects = [[NSMutableArray alloc] initWithCapacity:CLTraitMAX - 1];
        for (int traitID = 0 ; traitID < CLTraitMAX ; traitID++) {
            // find the object that corresponding to a given trait by matching the description. Typos are going to be bad :/
            NSDictionary *conf = [Trait getConfig:traitID];
            for (Trait *traitObject in traitList) {
                if ([traitObject.name isEqualToString:conf[@"name"]]) {
                    self.traitObjects[traitID] = traitObject;
                    break;
                }
            }
        }
    } failure:^(NSError *error) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"Cannot proceed. Failed to fetch traits" userInfo:nil];
    }];

    UINib *cellNib = [UINib nibWithNibName:@"NewAssessmentViewCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:@"NewAssessmentViewCell"];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;

    self.view.backgroundColor = UIColorFromHEX(CLColorGray);
    self.doneButton.backgroundColor = UIColorFromHEX(CLColorBlastOffRed);
    self.cancelButton.backgroundColor = UIColorFromHEX(CLColorBlastOffRed);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return CLTraitMAX;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NewAssessmentViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewAssessmentViewCell"];
    cell.traitType = (CLTraitType)indexPath.row;
    cell.backgroundColor = UIColorFromHEX(CLColorGray);
    cell.delegate = self;
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onCancel:(UIButton *)sender {
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onDone:(UIButton *)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    for (int traitID = 0 ; traitID < CLTraitMAX ; traitID++) {
        // Create a new record for each trait in the assessment
        CLModel *cli = [CLModel sharedInstance];
        [cli storeAssessmentForStudent:self.student
                                 trait:self.traitObjects[traitID]
                                 value:[self.assessmentValues[traitID] integerValue]
                               failure:^(NSError *error) {
                                   NSLog(@"Failed to record an assessment");
                               }];
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (void)updateAssessmentForTrait:(CLTraitType)traitType value:(NSInteger)value {
    self.assessmentValues[traitType] = @(value);
}

@end
