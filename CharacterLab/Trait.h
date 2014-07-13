//
//  Trait.h
//  CharacterLab
//
//  Created by Rajeev Nayak on 7/3/14.
//  Copyright (c) 2014 Dropbox. All rights reserved.
//

#import <Parse/Parse.h>

// PIER: we should get these from Parse but I did not want to spend too much time for the input view so I am just hardcoding them here
typedef enum : NSUInteger {
    CLTraitCuriosity          = 0,
    CLTraitGratitude          = 1,
    CLTraitGrit               = 2,
    CLTraitOptimism           = 3,
    CLTraitSelfControl        = 4,
    CLTraitSocialIntelligence = 5,
    CLTraitZest               = 6,
    CLTraitMAX                = 7,
} CLTraitType;

@interface Trait : PFObject <PFSubclassing>

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, copy) NSString *videoUrl;

+ (NSDictionary*)getConfig:(CLTraitType)traitType;

@end
