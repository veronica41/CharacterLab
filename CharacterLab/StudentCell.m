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
    self.backgroundColor = UIColorFromHEX(CLColorGray);

    // add a shadow to the top
    self.layer.shadowOffset = CGSizeMake(0, -1);
    self.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.layer.shadowRadius = 0.5;
    self.layer.shadowOpacity = 0.3;
}

- (void)setStudent:(Student *)student {
    _student = student;
    [self reloadData];
}

- (void)reloadData {
    self.initialsLabel.student = self.student;
    self.nameLabel.text = self.student.name;
    // TODO(rajeev): implement this
    self.lastMeasuredLabel.text = @"Today";
}

@end
