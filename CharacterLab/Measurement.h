//
//  Measurement.h
//  CharacterLab
//
//  Created by Pierpaolo Baccichet on 7/14/14.
//  Copyright (c) 2014 Dropbox. All rights reserved.
//

#import <Parse/Parse.h>
#import "Student.h"

@interface Measurement : PFObject <PFSubclassing>

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) Student *student;

@end
