//
//  TipCell.m
//  CharacterLab
//
//  Created by Veronica Zheng on 7/13/14.
//  Copyright (c) 2014 Dropbox. All rights reserved.
//

#import "TipCell.h"

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

@end
