//
//  BarGraphView.m
//  CharacterLab
//
//  Created by Pierpaolo Baccichet on 7/19/14.
//  Copyright (c) 2014 Dropbox. All rights reserved.
//

#import "BarGraphView.h"
#import "CLColor.h"
#import "Assessment.h"

static NSInteger const kBarStep = 39;

@interface BarGraphView ()

@property (weak, nonatomic) IBOutlet UIView *curiosityBarView;
@property (weak, nonatomic) IBOutlet UIView *gratitudeBarView;
@property (weak, nonatomic) IBOutlet UIView *gritBarView;
@property (weak, nonatomic) IBOutlet UIView *optimismBarView;
@property (weak, nonatomic) IBOutlet UIView *selfControlBarView;
@property (weak, nonatomic) IBOutlet UIView *socialIntelligenceBarView;
@property (weak, nonatomic) IBOutlet UIView *zestBarView;

@property (weak, nonatomic) IBOutlet UILabel *curiosityLabel;
@property (weak, nonatomic) IBOutlet UILabel *gratitudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *gritLabel;
@property (weak, nonatomic) IBOutlet UILabel *optimismLabel;
@property (weak, nonatomic) IBOutlet UILabel *selfControlLabel;
@property (weak, nonatomic) IBOutlet UILabel *socialIntelligenceLabel;
@property (weak, nonatomic) IBOutlet UILabel *zestLabel;

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

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
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
        [self addSubview:subview];
    }
}

- (void)setFrame:(UIView *)view width:(NSInteger)width {
    view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, width, view.frame.size.height);
}

- (void)drawGraphWithAnimation:(BOOL)animate
                assessmentList:(NSArray *)assessmentList {

    NSInteger curiosity = ((Assessment *)assessmentList[kTraitCuriosity]).score;
    NSInteger gratitude = ((Assessment *)assessmentList[kTraitGratitude]).score;
    NSInteger grit = ((Assessment *)assessmentList[kTraitGrit]).score;
    NSInteger optimism = ((Assessment *)assessmentList[kTraitOptimism]).score;
    NSInteger selfControl = ((Assessment *)assessmentList[kTraitSelfControl]).score;
    NSInteger socialIntelligence = ((Assessment *)assessmentList[kTraitSocialIntelligence]).score;
    NSInteger zest = ((Assessment *)assessmentList[kTraitZest]).score;

    static NSInteger const kMaxScoreInDB = 10;
    assert(curiosity > 0 && curiosity <= kMaxScoreInDB);
    assert(gratitude > 0 && gratitude <= kMaxScoreInDB);
    assert(grit > 0 && grit <= kMaxScoreInDB);
    assert(optimism > 0 && optimism <= kMaxScoreInDB);
    assert(selfControl > 0 && selfControl <= kMaxScoreInDB);
    assert(socialIntelligence > 0 && socialIntelligence <= kMaxScoreInDB);
    assert(zest > 0 && zest <= kMaxScoreInDB);

    // Clip data in the DB since we have some stuff that was going up to 10
    static NSInteger const kMaxScore = 7;
    curiosity = MIN(curiosity, kMaxScore);
    gratitude = MIN(gratitude, kMaxScore);
    grit = MIN(grit, kMaxScore);
    optimism = MIN(optimism, kMaxScore);
    selfControl = MIN(selfControl, kMaxScore);
    socialIntelligence = MIN(socialIntelligence, kMaxScore);
    zest = MIN(zest, kMaxScore);

    [self setFrame:self.curiosityBarView width:0];
    [self setFrame:self.gratitudeBarView width:0];
    [self setFrame:self.gritBarView width:0];
    [self setFrame:self.optimismBarView width:0];
    [self setFrame:self.selfControlBarView width:0];
    [self setFrame:self.socialIntelligenceBarView width:0];
    [self setFrame:self.zestBarView width:0];
    self.curiosityLabel.alpha = 0;
    self.gratitudeLabel.alpha = 0;
    self.gritLabel.alpha = 0;
    self.optimismLabel.alpha = 0;
    self.selfControlLabel.alpha = 0;
    self.socialIntelligenceLabel.alpha = 0;
    self.zestLabel.alpha = 0;

    [UIView animateWithDuration:1 delay:0.25 options:UIViewAnimationOptionCurveLinear animations:^{
        [self setFrame:self.curiosityBarView width:curiosity * kBarStep];
        [self setFrame:self.gratitudeBarView width:gratitude * kBarStep];
        [self setFrame:self.gritBarView width:grit * kBarStep];
        [self setFrame:self.optimismBarView width:optimism * kBarStep];
        [self setFrame:self.selfControlBarView width:selfControl * kBarStep];
        [self setFrame:self.socialIntelligenceBarView width:socialIntelligence * kBarStep];
        [self setFrame:self.zestBarView width:zest * kBarStep];
        
        // Fade in the labels
        self.curiosityLabel.alpha = 1;
        self.gratitudeLabel.alpha = 1;
        self.gritLabel.alpha = 1;
        self.optimismLabel.alpha = 1;
        self.selfControlLabel.alpha = 1;
        self.socialIntelligenceLabel.alpha = 1;
        self.zestLabel.alpha = 1;
    } completion:nil];
}



@end
