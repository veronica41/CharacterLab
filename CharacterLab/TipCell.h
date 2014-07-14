//
//  TipCell.h
//  CharacterLab
//
//  Created by Veronica Zheng on 7/13/14.
//  Copyright (c) 2014 Dropbox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TipCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *summaryLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *pageNumLabel;

@end
