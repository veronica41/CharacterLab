//
//  Student.m
//  CharacterLab
//
//  Created by Rajeev Nayak on 7/3/14.
//  Copyright (c) 2014 Dropbox. All rights reserved.
//

#import "Student.h"
#import <Parse/PFObject+Subclass.h>

@implementation Student

+ (NSString *)parseClassName {
    return @"Student";
}

@dynamic name;
@dynamic photoUrl;
@dynamic teacher;

@end
