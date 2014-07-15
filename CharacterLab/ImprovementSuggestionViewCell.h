//
//  ImprovementSuggestionViewCell.h
//  CharacterLab
//
//  Created by Pierpaolo Baccichet on 7/15/14.
//  Copyright (c) 2014 Dropbox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLModel.h"

@interface ImprovementSuggestionViewCell : UICollectionViewCell

@property (nonatomic, strong) Trait *trait1;
@property (nonatomic, strong) Trait *trait2;
@property (nonatomic, strong) Trait *trait3;
@property (weak, nonatomic) IBOutlet UILabel *pageNumLabel;

@end
