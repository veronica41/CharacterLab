//
//  TraitDetailViewController.m
//  CharacterLab
//
//  Created by Veronica Zheng on 7/7/14.
//  Copyright (c) 2014 Dropbox. All rights reserved.
//

#import "TraitDetailViewController.h"
#import "StudentsCollectionViewCell.h"

static NSString *kStudentsCellIdentifier = @"StudentsCellIdentifier";
static NSString *kActivitiesCellIDentifier = @"ActivitiesCellIdentifier";

@interface TraitDetailViewController ()

@property (weak, nonatomic) IBOutlet UICollectionView *activitiesCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *topStudentsCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *bottomStudentsCollectionView;
@property (nonatomic, strong) NSArray *topStudents;
@property (nonatomic, strong) NSArray *bottomStudents;

@end


@implementation TraitDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    /*
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [flowLayout setMinimumInteritemSpacing:16.0f];
    [flowLayout setMinimumLineSpacing:16.0f];
    [flowLayout setItemSize:CGSizeMake(84, 84)];
    */

    [self.activitiesCollectionView registerNib:[UINib nibWithNibName:@"TraitQuestionsView" bundle:nil] forCellWithReuseIdentifier:kActivitiesCellIDentifier];
    [self.topStudentsCollectionView registerClass:StudentsCollectionViewCell.class forCellWithReuseIdentifier:kStudentsCellIdentifier];
    [self.bottomStudentsCollectionView registerClass:StudentsCollectionViewCell.class forCellWithReuseIdentifier:kStudentsCellIdentifier];
    self.topStudentsCollectionView.dataSource = self;
    self.topStudentsCollectionView.delegate = self;
    self.bottomStudentsCollectionView.dataSource = self;
    self.bottomStudentsCollectionView.delegate = self;
    //[self.topStudentsCollectionView setCollectionViewLayout:flowLayout];
    //[self.bottomStudentsCollectionView setCollectionViewLayout:flowLayout];
   
    
    // TODO(veronica): get the top/bottom students on this traints
    [[Student query] findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.topStudents = objects;
        [self.topStudentsCollectionView reloadData];
    }];
    [[Student query] findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.bottomStudents = objects;
        [self.bottomStudentsCollectionView reloadData];
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == self.activitiesCollectionView) {
        return 2;
    } else if (collectionView == self.topStudentsCollectionView) {
        return self.topStudents.count;
    } else if (collectionView == self.bottomStudentsCollectionView) {
        return self.bottomStudents.count;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.activitiesCollectionView) {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kActivitiesCellIDentifier forIndexPath:indexPath];
        return cell;
    } else if (collectionView == self.topStudentsCollectionView) {
        StudentsCollectionViewCell *cell = (StudentsCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kStudentsCellIdentifier forIndexPath:indexPath];
        cell.student = [self.topStudents objectAtIndex:indexPath.row];
        return cell;
    } else if (collectionView == self.bottomStudentsCollectionView) {
        StudentsCollectionViewCell *cell = (StudentsCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kStudentsCellIdentifier forIndexPath:indexPath];
        cell.student = [self.bottomStudents objectAtIndex:indexPath.row];
        return cell;
    }
    return nil;
}

@end
