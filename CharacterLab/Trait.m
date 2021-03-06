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
@dynamic videoUrl;
@dynamic order;
@dynamic suggestion1;
@dynamic suggestion2;
@dynamic suggestion3;

@end
