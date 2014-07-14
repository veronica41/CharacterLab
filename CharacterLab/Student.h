//
//  Student.h
//  CharacterLab
//
//  Created by Rajeev Nayak on 7/3/14.
//  Copyright (c) 2014 Dropbox. All rights reserved.
//

#import <Parse/Parse.h>
#import "Teacher.h"

@interface Student : PFObject <PFSubclassing>

// These colors are used to associate an icon color with a student and are stored in the DB in Parse
typedef enum : NSUInteger {
    CLStudentColor_Red    = 1,
    CLStudentColor_Blue   = 2,
    CLStudentColor_Gray   = 3,
    CLStudentColor_Brown  = 4,
    CLStudentColor_Purple = 5,
    CLStudentColor_Orange = 6,
    CLStudentColor_MAX    = 7,
} CLStudentColor;

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *photoUrl;
@property (nonatomic, strong) Teacher *teacher;
@property (nonatomic, strong) NSDate *lastAssessmentTS;
@property (nonatomic, assign) NSInteger iconColor;

- (NSString *)initials;
- (UIColor *)getColorForIcon;

@end
