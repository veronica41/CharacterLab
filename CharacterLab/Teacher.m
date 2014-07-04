//
//  Teacher.m
//  CharacterLab
//
//  Created by Rajeev Nayak on 7/3/14.
//  Copyright (c) 2014 Dropbox. All rights reserved.
//

#import "Teacher.h"
#import <Parse/PFObject+Subclass.h>

@implementation Teacher

+ (NSString *)parseClassName {
    return @"Teacher";
}

@dynamic photoUrl;

@end
