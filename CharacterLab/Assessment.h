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

@property (nonatomic, copy, readonly) Student *student;
@property (nonatomic, copy, readonly) Trait *trait;
@property (nonatomic, assign, readonly) NSInteger score;

@end
