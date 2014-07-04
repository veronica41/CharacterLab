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

@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) NSURL *photoUrl;
@property (nonatomic, copy, readonly) Teacher *teacher;

@end
