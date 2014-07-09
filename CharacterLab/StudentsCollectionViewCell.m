//
//  StudentsCollectionViewCell.m
//  CharacterLab
//
//  Created by Veronica Zheng on 7/8/14.
//  Copyright (c) 2014 Dropbox. All rights reserved.
//

#import "StudentsCollectionViewCell.h"
#import <UIImageView+AFNetworking.h>

@interface StudentsCollectionViewCell ()

@property (nonatomic, strong) UIImageView *imageView;

@end


@implementation StudentsCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] initWithFrame:frame];
        [self.contentView addSubview:self.imageView];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)setStudent:(Student *)student {
    _student = student;
    [self reloadData];
}

- (void)reloadData {
    self.imageView.image = nil;
    [self.imageView setImageWithURL:[NSURL URLWithString:self.student.photoUrl]];
}

@end
