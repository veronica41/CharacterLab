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

@property (weak, nonatomic) IBOutlet UIImageView *traitImage1;
@property (weak, nonatomic) IBOutlet UIImageView *traitImage2;
@property (weak, nonatomic) IBOutlet UIImageView *traitImage3;
@property (weak, nonatomic) IBOutlet UILabel *traitLabel1;
@property (weak, nonatomic) IBOutlet UILabel *traitLabel2;
@property (weak, nonatomic) IBOutlet UILabel *traitLabel3;
@property (weak, nonatomic) IBOutlet UILabel *pageNumLabel;

@end
