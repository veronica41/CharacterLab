//
//  StudentCell.m
//  CharacterLab
//
//  Created by Rajeev Nayak on 7/5/14.
//  Copyright (c) 2014 Dropbox. All rights reserved.
//

#import "StudentCell.h"
#import "CLColor.h"
#import "StudentInitialsLabel.h"
#import <DateTools.h>

@interface StudentCell ()

@property (weak, nonatomic) IBOutlet UIView *topBackgroundView;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet StudentInitialsLabel *initialsLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastMeasuredLabel;

@end

@implementation StudentCell

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
    self.useDarkTopBackground = false;
}

- (void)setStudent:(Student *)student {
    _student = student;
    [self reloadData];
}

- (void)setUseDarkTopBackground:(BOOL)useDarkTopBackground {
    _useDarkTopBackground = useDarkTopBackground;
    self.topBackgroundView.backgroundColor = useDarkTopBackground ? UIColorFromHEX(CLColorDarkGray) : UIColorFromHEX(CLColorBackgroundGrey);
}

- (void)reloadData {
    self.containerView.layer.shadowColor = [UIColorFromHEX(CLColorShadowGrey) CGColor];

    if (self.student != nil) {
        self.initialsLabel.student = self.student;
        self.initialsLabel.alpha = 1;
        self.nameLabel.textColor = [UIColor whiteColor];
        self.nameLabel.text = self.student.name;
        self.lastMeasuredLabel.text = self.student.lastAssessmentTS.timeAgoSinceNow;
    } else {
        self.initialsLabel.alpha = 0;
        self.nameLabel.textColor = UIColorFromHEX(CLColorAquamarine);
        self.nameLabel.text = @"Add New Student";
        self.lastMeasuredLabel.text = @"";
    }
}

@end
