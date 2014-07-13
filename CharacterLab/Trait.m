//
//  Trait.m
//  CharacterLab
//
//  Created by Rajeev Nayak on 7/3/14.
//  Copyright (c) 2014 Dropbox. All rights reserved.
//

#import "Trait.h"
#import <Parse/PFObject+Subclass.h>

@implementation Trait

+ (NSString *)parseClassName {
    return @"Trait";
}

@dynamic name;
@dynamic desc;
@dynamic imageUrl;

+ (NSDictionary*)getConfig:(CLTraitType)traitType {
    switch (traitType) {
        case CLTraitCuriosity:
            return @{@"icon": @"curiosityCircle",
                     @"name": @"Curiosity"};
        case CLTraitGratitude:
            return @{@"icon": @"gratitudeCircle",
                     @"name": @"Gratitude"};
        case CLTraitGrit:
            return @{@"icon": @"gritCircle",
                     @"name": @"Grit"};
        case CLTraitOptimism:
            return @{@"icon": @"optimismCircle",
                     @"name": @"Optimism"};
        case CLTraitSelfControl:
            return @{@"icon": @"selfcontrolCircle",
                     @"name": @"Self-Control"};
        case CLTraitSocialIntelligence:
            return @{@"icon": @"socialintelligenceCircle",
                     @"name": @"Social Intelligence"};
        case CLTraitZest:
            return @{@"icon": @"zestCircle",
                     @"name": @"Zest"};
        default:
            @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"invalid category" userInfo:nil];
    }
}

@end
