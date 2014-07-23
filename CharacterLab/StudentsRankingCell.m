//
//  StudentsRankingCell.m
//  CharacterLab
//
//  Created by Veronica Zheng on 7/19/14.
//  Copyright (c) 2014 Dropbox. All rights reserved.
//

#import "StudentsRankingCell.h"
#import "StudentProfileViewController.h"
#import "UIImageView+AFNetworking.h"

@interface StudentsRankingCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end


@implementation StudentsRankingCell

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
    self.imageView.image = nil;
    [self addObserver:self forKeyPath:@"imageView" options:NSKeyValueObservingOptionNew context:nil];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
    [self addGestureRecognizer:tap];
}

- (void)dealloc {
    self.imageView = nil;
    self.nameLabel = nil;
    [self removeObserver:self forKeyPath:@"imageView"];
}

- (void)setStudent:(Student *)student {
    _student = student;
    [self.imageView setImageWithURL:[NSURL URLWithString:student.photoUrl]];
    self.nameLabel.text = student.name;
    [self setNeedsDisplay];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"imageView"]) {
        [self.imageView.layer setMasksToBounds:YES];
        [self.imageView.layer setCornerRadius:self.imageView.bounds.size.height/2.0f];
    }
}

- (void)onTap:(id)sender {
    [self.delegate studentOnTap:self.student];
}

@end
