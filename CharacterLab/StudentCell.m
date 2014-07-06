//
//  StudentCell.m
//  CharacterLab
//
//  Created by Rajeev Nayak on 7/5/14.
//  Copyright (c) 2014 Dropbox. All rights reserved.
//

#import "StudentCell.h"
#import <UIImageView+AFNetworking.h>

@interface StudentCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation StudentCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setStudent:(Student *)student {
    _student = student;
    [self reloadData];
}

- (void)reloadData {
    self.imageView.image = nil;
    [self.imageView setImageWithURL:[NSURL URLWithString:self.student.photoUrl]];
    self.nameLabel.text = self.student.name;
}

@end
