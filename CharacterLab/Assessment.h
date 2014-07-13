//
//  Assessment.h
//  CharacterLab
//
//  Created by Rajeev Nayak on 7/3/14.
//  Copyright (c) 2014 Dropbox. All rights reserved.
//

#import <Parse/Parse.h>
#import "Student.h"
#import "Trait.h"

@interface Assessment : PFObject <PFSubclassing>

typedef enum : NSUInteger {
    CLAssessmentScore_1    = 1,
    CLAssessmentScore_2    = 2,
    CLAssessmentScore_3    = 3,
    CLAssessmentScore_4    = 4,
    CLAssessmentScore_5    = 5,
    CLAssessmentScore_6    = 6,
    CLAssessmentScore_7    = 7,
    CLAssessmentScore_8    = 8,
    CLAssessmentScore_9    = 9,
    CLAssessmentScore_10   = 10,
    CLAssessmentScore_MAX  = 11,
} CLAssessmentScore;

@property (nonatomic, strong) Student *student;
@property (nonatomic, strong) Trait *trait;
@property (nonatomic, assign) CLAssessmentScore score; // 1 to 10

@end
