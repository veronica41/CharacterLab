//
//  TraitDetailViewController.h
//  CharacterLab
//
//  Created by Veronica Zheng on 7/7/14.
//  Copyright (c) 2014 Dropbox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StudentsRankingCell.h"
#import "CLModel.h"

@interface TraitDetailViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, StudentRankCellDelegate>

@property (nonatomic, strong) Trait *trait;
@property (weak, nonatomic) IBOutlet UIView *titleBar;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (nonatomic, strong) CALayer *titleBarBorder;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *titleBarBackgroundHackView;
@property (weak, nonatomic) IBOutlet UIImageView *traitImageView;
@property (weak, nonatomic) IBOutlet UIView *traitDescriptionContainerView;
@property (weak, nonatomic) IBOutlet UILabel *aboutLabel;
@property (weak, nonatomic) IBOutlet UIView *movieView;

@end