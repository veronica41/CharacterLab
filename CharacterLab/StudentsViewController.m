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

@interface StudentsViewController ()

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

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
    return self.students.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    StudentCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"StudentCell" forIndexPath:indexPath];
    cell.student = self.students[indexPath.row];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];

    StudentProfileViewController *spvc = [[StudentProfileViewController alloc] init];
    spvc.student = self.students[indexPath.row];
    [self presentViewController:spvc animated:NO completion:nil];
}

@end
