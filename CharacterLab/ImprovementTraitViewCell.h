//
//  ImprovementTraitViewCell.h
//  CharacterLab
//
//  Created by Pierpaolo Baccichet on 7/15/14.
//  Copyright (c) 2014 Dropbox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImprovementTraitViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *suggestion1Label;
@property (weak, nonatomic) IBOutlet UILabel *suggestion2Label;
@property (weak, nonatomic) IBOutlet UILabel *suggestion3Label;
@property (weak, nonatomic) IBOutlet UILabel *pageNumLabel;

@end
