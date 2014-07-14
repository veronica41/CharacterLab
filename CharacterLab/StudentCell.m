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
    self.backgroundColor = UIColorFromHEX(CLColorBackgroundGrey);

    // add a shadow to the top
    self.layer.shadowOffset = CGSizeMake(0, -1);
    self.layer.shadowColor = [UIColorFromHEX(CLColorShadowGrey) CGColor];
    self.layer.shadowRadius = 0.5;
    self.layer.shadowOpacity = 1;
}

- (void)setStudent:(Student *)student {
    _student = student;
    [self reloadData];
}

- (void)reloadData {
    self.initialsLabel.student = self.student;
    self.nameLabel.text = self.student.name;
    self.lastMeasuredLabel.text = self.student.lastAssessmentTS.timeAgoSinceNow;;
}

@end
