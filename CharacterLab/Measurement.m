//
//  Measurement.m
//  CharacterLab
//
//  Created by Pierpaolo Baccichet on 7/14/14.
//  Copyright (c) 2014 Dropbox. All rights reserved.
//

#import "Measurement.h"
#import <Parse/PFObject+Subclass.h>

@implementation Measurement

+ (NSString *)parseClassName {
    return @"Measurement";
}

@dynamic description;
@dynamic createdAt;

@end
