//
//  Question.m
//  CharacterLab
//
//  Created by Rajeev Nayak on 7/3/14.
//  Copyright (c) 2014 Dropbox. All rights reserved.
//

#import "Question.h"
#import <Parse/PFObject+Subclass.h>

@implementation Question

+ (NSString *)parseClassName {
    return @"Question";
}

@dynamic text;
@dynamic trait;

@end
