//
//  NewAssessmentViewCell.m
//  CharacterLab
//
//  Created by Pierpaolo Baccichet on 7/13/14.
//  Copyright (c) 2014 Dropbox. All rights reserved.
//

#import "CLColor.h"
#import "NewAssessmentViewCell.h"

@interface NewAssessmentViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *assessmentLabel;
- (IBAction)onSliderUpdate:(UISlider *)sender;

@end

@implementation NewAssessmentViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTraitType:(CLTraitType)traitType {
    NSDictionary *conf = [Trait getConfig:traitType];
    _traitType = traitType;
    self.iconImage.image = [UIImage imageNamed:conf[@"icon"]];
    self.descriptionLabel.text = conf[@"name"];
}

- (IBAction)onSliderUpdate:(UISlider *)sender {
    int val = (int)sender.value;
    self.assessmentValue = val;
    self.assessmentLabel.text = [NSString stringWithFormat:@"%d", val];
    [self.delegate updateAssessmentForTrait:self.traitType value:val];
}

@end
