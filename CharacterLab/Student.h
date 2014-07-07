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

@property (nonatomic, copy) NSString *name;
// PIER: can we make this a NSURL?
@property (nonatomic, copy) NSString *photoUrl;
@property (nonatomic, strong) Teacher *teacher;

@end
