//
//  Teacher.h
//  CharacterLab
//
//  Created by Rajeev Nayak on 7/3/14.
//  Copyright (c) 2014 Dropbox. All rights reserved.
//

#import <Parse/Parse.h>

@interface Teacher : PFUser <PFSubclassing>

@property (nonatomic, copy, readonly) NSString *photoUrl;

@end
