//
//  Trait.h
//  CharacterLab
//
//  Created by Rajeev Nayak on 7/3/14.
//  Copyright (c) 2014 Dropbox. All rights reserved.
//

#import <Parse/Parse.h>

#define NUM_TRAITS 7

// Constants to lookup traits in local sorted arrays. MUST match the server side order
static NSInteger const kTraitCuriosity = 0;
static NSInteger const kTraitGratitude = 1;
static NSInteger const kTraitGrit = 2;
static NSInteger const kTraitOptimism = 3;
static NSInteger const kTraitSelfControl = 4;
static NSInteger const kTraitSocialIntelligence = 5;
static NSInteger const kTraitZest = 6;

@interface Trait : PFObject <PFSubclassing>

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, copy) NSString *videoUrl;
@property (nonatomic, assign) NSInteger order;
@property (nonatomic, copy) NSString *suggestion1;
@property (nonatomic, copy) NSString *suggestion2;
@property (nonatomic, copy) NSString *suggestion3;

@end
