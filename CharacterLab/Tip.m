//
//  Tips.m
//  CharacterLab
//
//  Created by Veronica Zheng on 7/13/14.
//  Copyright (c) 2014 Dropbox. All rights reserved.
//

#import "Tip.h"
#import <Parse/PFObject+Subclass.h>

@implementation Tip

+ (NSString *)parseClassName {
    return @"Tip";
}

@dynamic summary;
@dynamic desc;
@dynamic trait;

@end