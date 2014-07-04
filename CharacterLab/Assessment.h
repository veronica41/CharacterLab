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

@property (nonatomic, copy) Student *student;
@property (nonatomic, copy) Trait *trait;
@property (nonatomic, assign) NSInteger score;

@end
