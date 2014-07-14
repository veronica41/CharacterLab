//
//  Assessment.m
//  CharacterLab
//
//  Created by Rajeev Nayak on 7/3/14.
//  Copyright (c) 2014 Dropbox. All rights reserved.
//

#import "Assessment.h"
#import <Parse/PFObject+Subclass.h>

@implementation Assessment

+ (NSString *)parseClassName {
    return @"Assessment";
}

@dynamic student;
@dynamic measurement;
@dynamic trait;
@dynamic score;

@end
