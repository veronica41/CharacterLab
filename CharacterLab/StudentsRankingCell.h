//
//  StudentsRankingCell.h
//  CharacterLab
//
//  Created by Veronica Zheng on 7/19/14.
//  Copyright (c) 2014 Dropbox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StudentInitialsLabel.h"

@protocol StudentRankCellDelegate <NSObject>

- (void)studentOnTap:(Student *)student;

@end


@interface StudentsRankingCell : UICollectionViewCell

@property (nonatomic, strong) Student *student;
@property (nonatomic, strong) id<StudentRankCellDelegate> delegate;

@end
