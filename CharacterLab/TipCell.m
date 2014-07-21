//
//  TipCell.m
//  CharacterLab
//
//  Created by Veronica Zheng on 7/13/14.
//  Copyright (c) 2014 Dropbox. All rights reserved.
//

#import "TipCell.h"

#define DEFAULT_CONTENT_HEIGHT 49

@interface TipCell ()
@end

@implementation TipCell

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
}

- (CGFloat)contentHeight {
    UILabel * label = [[UILabel alloc] initWithFrame:self.descLabel.frame];
    label.numberOfLines = 0;
    label.attributedText = self.descLabel.attributedText;
    [label sizeToFit];
    return DEFAULT_CONTENT_HEIGHT + label.bounds.size.height;
}

@end
