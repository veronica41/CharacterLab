//
//  TraitDetailViewController.h
//  CharacterLab
//
//  Created by Veronica Zheng on 7/7/14.
//  Copyright (c) 2014 Dropbox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLModel.h"

@interface TraitDetailViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) Trait *trait;
@property (weak, nonatomic) IBOutlet UIView *titleBar;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *traitImageView;
@property (weak, nonatomic) IBOutlet UIView *traitDescriptionContainerView;

@end