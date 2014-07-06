//
//  TouchInterceptingContainerView.m
//  CharacterLab
//
//  Created by Rajeev Nayak on 7/8/14.
//  Copyright (c) 2014 Dropbox. All rights reserved.
//

#import "TouchInterceptingContainerView.h"

@implementation TouchInterceptingContainerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    // pass touch events to the content view
    UIView *view = [super hitTest:point withEvent:event];
    if (view == self) {
        return self.contentView;
    }
    return view;
}

@end
