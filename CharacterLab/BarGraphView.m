//
//  BarGraphView.m
//  CharacterLab
//
//  Created by Pierpaolo Baccichet on 7/19/14.
//  Copyright (c) 2014 Dropbox. All rights reserved.
//

#import "BarGraphView.h"
#import "CLColor.h"

static NSInteger const kBarStep = 44;

@interface BarGraphView ()

@property (weak, nonatomic) IBOutlet UIView *curiosityBarView;
@property (weak, nonatomic) IBOutlet UIView *gratitudeBarView;
@property (weak, nonatomic) IBOutlet UIView *gritBarView;
@property (weak, nonatomic) IBOutlet UIView *optimismBarView;
@property (weak, nonatomic) IBOutlet UIView *selfControlBarView;
@property (weak, nonatomic) IBOutlet UIView *socialIntelligenceBarView;
@property (weak, nonatomic) IBOutlet UIView *zestBarView;

@end

@implementation BarGraphView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    if (self.subviews.count == 0) {
        UINib *nib = [UINib nibWithNibName:@"BarGraphView" bundle:nil];
        UIView *subview = [[nib instantiateWithOwner:self options:nil] objectAtIndex:0];
        subview.frame = self.bounds;
        subview.backgroundColor = UIColorFromHEX(CLColorDarkGray);
        [self addSubview:subview];
    }
}

- (void)setFrame:(UIView *)view width:(NSInteger)width {
    view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, width, view.frame.size.height);
}

- (void)drawGraphWithAnimation:(BOOL)animate
                     curiosity:(NSInteger)curiosity
                     gratitude:(NSInteger)gratitude
                          grit:(NSInteger)grit
                      optimism:(NSInteger)optimism
                   selfControl:(NSInteger)selfControl
            socialIntelligence:(NSInteger)socialIntelligence
                          zest:(NSInteger)zest {

    assert(curiosity > 0 && curiosity <= 7);
    assert(gratitude > 0 && gratitude <= 7);
    assert(grit > 0 && grit <= 7);
    assert(optimism > 0 && optimism <= 7);
    assert(selfControl > 0 && selfControl <= 7);
    assert(socialIntelligence > 0 && socialIntelligence <= 7);
    assert(zest > 0 && zest <= 7);

    [self setFrame:self.curiosityBarView width:0];
    [self setFrame:self.gratitudeBarView width:0];
    [self setFrame:self.gritBarView width:0];
    [self setFrame:self.optimismBarView width:0];
    [self setFrame:self.selfControlBarView width:0];
    [self setFrame:self.socialIntelligenceBarView width:0];
    [self setFrame:self.zestBarView width:0];

    [self setFrame:self.curiosityBarView width:curiosity * kBarStep];
    [self setFrame:self.gratitudeBarView width:gratitude * kBarStep];
    [self setFrame:self.gritBarView width:grit * kBarStep];
    [self setFrame:self.optimismBarView width:optimism * kBarStep];
    [self setFrame:self.selfControlBarView width:selfControl * kBarStep];
    [self setFrame:self.socialIntelligenceBarView width:socialIntelligence * kBarStep];
    [self setFrame:self.zestBarView width:zest * kBarStep];
}



@end
