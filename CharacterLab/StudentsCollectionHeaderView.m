//
//  StudentsTableHeaderView.m
//  CharacterLab
//
//  Created by Rajeev Nayak on 7/12/14.
//  Copyright (c) 2014 Dropbox. All rights reserved.
//

#import "StudentsCollectionHeaderView.h"
#import "CLColor.h"

@implementation StudentsCollectionHeaderView

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
    UINib *nib = [UINib nibWithNibName:@"StudentsCollectionHeaderView" bundle:nil];
    NSArray *objects = [nib instantiateWithOwner:self options:nil];
    UIView *view = objects[0];
    view.backgroundColor = UIColorFromHEX(CLColorDarkGray);
    [self addSubview:view];
}

@end
