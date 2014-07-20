//
//  StudentsRankingCell.h
//  CharacterLab
//
//  Created by Veronica Zheng on 7/19/14.
//  Copyright (c) 2014 Dropbox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StudentInitialsLabel.h"

@interface StudentsRankingCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet StudentInitialsLabel *initialsLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end
