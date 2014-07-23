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

@property (nonatomic, assign) BOOL initializedShadow;

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
    self.useDarkTopBackground = NO;
    self.initializedShadow = NO;
}

- (void)setStudent:(Student *)student {
    _student = student;
    [self reloadData];
}

- (void)setUseDarkTopBackground:(BOOL)useDarkTopBackground {
    _useDarkTopBackground = useDarkTopBackground;
    self.topBackgroundView.backgroundColor = useDarkTopBackground ? UIColorFromHEX(CLColorDarkGrey) : UIColorFromHEX(CLColorBackgroundGrey);
}

- (void)reloadData {
    if (!self.initializedShadow) {
        CAShapeLayer* shadowLayer = [CAShapeLayer layer];
        shadowLayer.frame = CGRectMake(0, 0.3, self.containerView.bounds.size.width, 10);
        shadowLayer.backgroundColor = [UIColorFromHEX(CLColorBackgroundGrey) CGColor];
        shadowLayer.cornerRadius = 10;
        shadowLayer.shadowRadius = 0;
        shadowLayer.shadowColor = [[UIColor whiteColor] CGColor];
        shadowLayer.shadowOpacity = 0.1;
        shadowLayer.shadowOffset = CGSizeMake(0, -0.3);
        [self.containerView.layer addSublayer:shadowLayer];

        self.containerView.layer.shadowColor = [UIColorFromHEX(CLColorShadowGrey) CGColor];

        self.initializedShadow = YES;
    }

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
