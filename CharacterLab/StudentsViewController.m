//
//  StudentsViewController.m
//  CharacterLab
//
//  Created by Rajeev Nayak on 7/5/14.
//  Copyright (c) 2014 Dropbox. All rights reserved.
//

#import "CLModel.h"

#import "StudentsViewController.h"
#import "StudentCell.h"
#import "StudentProfileViewController.h"
#import "StudentsCollectionHeaderView.h"
#import "CLColor.h"

@interface StudentsViewController ()

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
- (IBAction)onBackButton:(id)sender;

@property (nonatomic, strong) NSArray *students;

@end

@implementation StudentsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Students";
    }
    return self;
}

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // init the collection view
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    UINib *studentCellNib = [UINib nibWithNibName:@"StudentCell" bundle:nil];
    [self.collectionView registerNib:studentCellNib forCellWithReuseIdentifier:@"StudentCell"];
    [self.collectionView registerClass:[StudentsCollectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header"];

    [[CLModel sharedInstance] getStudentsForCurrentTeacherWithSuccess:^(NSArray *studentList) {
        self.students = studentList;
        [self.collectionView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"Failed to fetch student list");
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    // +1 for the Add New Student item
    return self.students.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    StudentCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"StudentCell" forIndexPath:indexPath];
    if (indexPath.row == self.students.count) {
        cell.student = nil;
    } else {
        cell.student = self.students[indexPath.row];
    }
    // give the first cell a dark top background to match the header view background
    cell.useDarkTopBackground = (indexPath.row == 0);
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    return [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header" forIndexPath:indexPath];
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];

    if (indexPath.row == self.students.count) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Not implemented yet" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    } else {
        StudentProfileViewController *spvc = [[StudentProfileViewController alloc] init];
        spvc.student = self.students[indexPath.row];
        [self presentViewController:spvc animated:YES completion:nil];
    }
}

#pragma mark - event handlers

- (IBAction)onBackButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
