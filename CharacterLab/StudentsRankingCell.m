//
//  StudentsRankingCell.m
//  CharacterLab
//
//  Created by Veronica Zheng on 7/19/14.
//  Copyright (c) 2014 Dropbox. All rights reserved.
//

#import "StudentsRankingCell.h"

@implementation StudentsRankingCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addObserver:self forKeyPath:@"imageView" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self addObserver:self forKeyPath:@"imageView" options:NSKeyValueObservingOptionNew context:nil];

    }
    return self;
}

- (void)dealloc {
    self.imageView = nil;
    self.nameLabel = nil;
    [self removeObserver:self forKeyPath:@"imageView"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"imageView"]) {
        [self.imageView.layer setMasksToBounds:YES];
        [self.imageView.layer setCornerRadius:self.imageView.bounds.size.height/2.0f];
    }
}



@end
