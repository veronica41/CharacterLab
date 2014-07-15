//
//  ImprovementSuggestionViewCell.m
//  CharacterLab
//
//  Created by Pierpaolo Baccichet on 7/15/14.
//  Copyright (c) 2014 Dropbox. All rights reserved.
//

#import "ImprovementSuggestionViewCell.h"

@interface ImprovementSuggestionViewCell ()

- (IBAction)onTrait1Tap:(UITapGestureRecognizer *)sender;
- (IBAction)onTrait2Tap:(UITapGestureRecognizer *)sender;
- (IBAction)onTrait3Tap:(UITapGestureRecognizer *)sender;

@property (nonatomic, strong) UITapGestureRecognizer *rec1;
@property (nonatomic, strong) UITapGestureRecognizer *rec2;
@property (nonatomic, strong) UITapGestureRecognizer *rec3;

@end

@implementation ImprovementSuggestionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
    }
    return self;
}

- (void)setup {
    self.layer.cornerRadius = 5.0;
    if (self.rec1 == nil) {
        self.rec1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTrait1Tap:)];
        [self.traitImage1 addGestureRecognizer:self.rec1];
    }
    if (self.rec2 == nil) {
        self.rec2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTrait2Tap:)];
        [self.traitImage2 addGestureRecognizer:self.rec2];
    }
    if (self.rec3 == nil) {
        self.rec3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTrait3Tap:)];
        [self.traitImage3 addGestureRecognizer:self.rec3];
    }
}

- (IBAction)onTrait1Tap:(UITapGestureRecognizer *)sender {
    [self.delegate updateSelectedSuggestionItem:1];
}

- (IBAction)onTrait2Tap:(UITapGestureRecognizer *)sender {
    [self.delegate updateSelectedSuggestionItem:2];
}

- (IBAction)onTrait3Tap:(UITapGestureRecognizer *)sender {
    [self.delegate updateSelectedSuggestionItem:3];
}

@end
