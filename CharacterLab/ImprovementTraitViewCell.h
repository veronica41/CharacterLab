//
//  ImprovementTraitViewCell.h
//  CharacterLab
//
//  Created by Pierpaolo Baccichet on 7/15/14.
//  Copyright (c) 2014 Dropbox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImprovementTraitViewCell : UICollectionViewCell

@property (nonatomic, strong) NSString *suggestion1;
@property (nonatomic, strong) NSString *suggestion2;
@property (nonatomic, strong) NSString *suggestion3;
@property (weak, nonatomic) IBOutlet UILabel *pageNumLabel;

@end
