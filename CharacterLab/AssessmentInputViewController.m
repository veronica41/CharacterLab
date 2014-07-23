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

@interface AssessmentInputViewController () <UITableViewDataSource, UITableViewDelegate, NewAssessmentViewCellDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *assessmentValues;
@property (weak, nonatomic) IBOutlet UITextField *descriptionText;

@property (nonatomic, strong) NSMutableArray *traitObjects;

- (IBAction)onCancel:(UIButton *)sender;
- (IBAction)onDone:(UIButton *)sender;
- (IBAction)onDescriptionEditBegin:(UITextField *)sender;
- (IBAction)onDescriptionEditEnd:(UITextField *)sender;
- (IBAction)onTap:(UITapGestureRecognizer *)sender;

@end

@implementation AssessmentInputViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.assessmentValues = [NSMutableArray array];
        for (int traitID = 0 ; traitID < NUM_TRAITS ; traitID++) {
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
        self.traitObjects = [[NSMutableArray alloc] initWithCapacity:NUM_TRAITS];
        for (int x = 0 ; x < NUM_TRAITS ; x++) {
            self.traitObjects[x] = @"";
        }
        for (Trait *traitObject in traitList) {
            self.traitObjects[traitObject.order] = traitObject;
        }
    } failure:^(NSError *error) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"Cannot proceed. Failed to fetch traits" userInfo:nil];
    }];

    UINib *cellNib = [UINib nibWithNibName:@"NewAssessmentViewCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:@"NewAssessmentViewCell"];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.descriptionText.delegate = self;
    [self.descriptionText becomeFirstResponder];

    self.view.backgroundColor = UIColorFromHEX(CLColorGray);
    self.doneButton.backgroundColor = UIColorFromHEX(CLColorBlastOffRed);
    self.cancelButton.backgroundColor = UIColorFromHEX(CLColorBlastOffRed);
    self.doneButton.layer.cornerRadius = 5;
    self.cancelButton.layer.cornerRadius = 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return NUM_TRAITS;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NewAssessmentViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewAssessmentViewCell"];
    cell.traitType = indexPath.row;
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
    CLModel *CLClient = [CLModel sharedInstance];

    // 1) create a measurement, 2) store the trait scores and 3) update the student timestamp
    // This is a bit slow and all synchronous to avoid having to deal with async refresh of the student detail view for now
    Measurement *measurement = [CLClient storeMeasurementForStudent:self.student title:self.descriptionText.text failure:nil];
    for (int traitID = 0 ; traitID < NUM_TRAITS ; traitID++) {
        // Create a new record for each trait in the assessment
        [CLClient storeAssessmentForStudent:self.student
                                measurement:measurement
                                      trait:self.traitObjects[traitID]
                                      value:[self.assessmentValues[traitID] integerValue]
                                    failure:^(NSError *error) {
                                        NSLog(@"Failed to record an assessment");
                                    }];
    }
    [CLClient updateStudent:self.student measurement:measurement failure:nil];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onDescriptionEditBegin:(UITextField *)sender {
    if ([sender.text isEqualToString:@"add description"]) {
        sender.text = @"";
    }
}

- (IBAction)onDescriptionEditEnd:(UITextField *)sender {
    [self.view endEditing:YES];
}

- (IBAction)onTap:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (void)updateAssessmentForTrait:(NSInteger)traitType value:(NSInteger)value {
    self.assessmentValues[traitType] = @(value);
}

@end
