//
//  ImprovementSuggestionViewCell.m
//  CharacterLab
//
//  Created by Pierpaolo Baccichet on 7/15/14.
//  Copyright (c) 2014 Dropbox. All rights reserved.
//

#import "ImprovementSuggestionViewCell.h"

@interface ImprovementSuggestionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *traitImage1;
@property (weak, nonatomic) IBOutlet UIImageView *traitImage2;
@property (weak, nonatomic) IBOutlet UIImageView *traitImage3;
@property (weak, nonatomic) IBOutlet UILabel *traitLabel1;
@property (weak, nonatomic) IBOutlet UILabel *traitLabel2;
@property (weak, nonatomic) IBOutlet UILabel *traitLabel3;

@end

@implementation ImprovementSuggestionViewCell

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
    self.traitLabel1.text = self.trait1.name;
    self.traitLabel2.text = self.trait2.name;
    self.traitLabel3.text = self.trait3.name;
    self.traitImage1.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@Circle", [self.trait1.name lowercaseString]]];
    self.traitImage2.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@Circle", [self.trait2.name lowercaseString]]];
    self.traitImage3.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@Circle", [self.trait3.name lowercaseString]]];
}

@end
