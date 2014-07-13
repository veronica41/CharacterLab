//
//  StudentInitialsView.m
//  CharacterLab
//
//  Created by Rajeev Nayak on 7/12/14.
//  Copyright (c) 2014 Dropbox. All rights reserved.
//

#import "StudentInitialsLabel.h"

@implementation StudentInitialsLabel

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
    self.layer.cornerRadius = self.frame.size.width / 2;
}

- (void)setStudent:(Student *)student {
    _student = student;
    [self reloadData];
}

- (void)reloadData {
    self.text = [self.student initials];
}

@end
