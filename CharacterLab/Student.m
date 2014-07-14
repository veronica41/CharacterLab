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
@dynamic lastAssessmentTS;
@dynamic iconColor;

- (NSString *)initials {
    NSArray *nameComponents = [self.name componentsSeparatedByString: @" "];
    int cnt = [nameComponents count];
    NSMutableString *ret_val = [@"" mutableCopy];

    if (cnt > 0) {
        [ret_val appendFormat:@"%c", [nameComponents[0] characterAtIndex:0]];
        if (cnt > 1) {
            [ret_val appendFormat:@"%c", [nameComponents[1] characterAtIndex:0]];
        }
    }
    return [ret_val uppercaseString];
}

- (UIColor *)getColorForIcon {
    switch (self.iconColor) {
        case CLStudentColor_Red:
            return [UIColor redColor];
        case CLStudentColor_Blue:
            return [UIColor blueColor];
        case CLStudentColor_Green:
            return [UIColor greenColor];
        case CLStudentColor_Gray:
            return [UIColor grayColor];
        case CLStudentColor_Cyan:
            return [UIColor cyanColor];
        case CLStudentColor_Yellow:
            return [UIColor yellowColor];
        case CLStudentColor_Brown:
            return [UIColor brownColor];
        case CLStudentColor_Purple:
            return [UIColor purpleColor];
        case CLStudentColor_Orange:
            return [UIColor orangeColor];
        default:
            // Default to white to show holes
            return [UIColor whiteColor];
    }
}

@end
