//
//  NewAssessmentViewCell.h
//  CharacterLab
//
//  Created by Pierpaolo Baccichet on 7/13/14.
//  Copyright (c) 2014 Dropbox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLModel.h"

@protocol NewAssessmentViewCellDelegate <NSObject>

- (void)updateAssessmentForTrait:(NSInteger)traitType value:(NSInteger)value;

@end

@interface NewAssessmentViewCell : UITableViewCell

@property (nonatomic, assign) NSInteger traitType;
@property (nonatomic, assign) NSInteger assessmentValue;
@property (nonatomic, retain) id <NewAssessmentViewCellDelegate> delegate;

@end
