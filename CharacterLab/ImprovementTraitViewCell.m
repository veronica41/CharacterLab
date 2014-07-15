//
//  ImprovementTraitViewCell.m
//  CharacterLab
//
//  Created by Pierpaolo Baccichet on 7/15/14.
//  Copyright (c) 2014 Dropbox. All rights reserved.
//

#import "ImprovementTraitViewCell.h"

@interface ImprovementTraitViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *suggestion1Label;
@property (weak, nonatomic) IBOutlet UILabel *suggestion2Label;
@property (weak, nonatomic) IBOutlet UILabel *suggestion3Label;

@end

@implementation ImprovementTraitViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.layer.cornerRadius = 5.0;
    self.suggestion1Label.text = self.suggestion1;
    self.suggestion2Label.text = self.suggestion2;
    self.suggestion3Label.text = self.suggestion3;
}

@end
