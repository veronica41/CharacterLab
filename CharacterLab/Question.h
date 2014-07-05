//
//  Question.h
//  CharacterLab
//
//  Created by Rajeev Nayak on 7/3/14.
//  Copyright (c) 2014 Dropbox. All rights reserved.
//

#import <Parse/Parse.h>
#import "Trait.h"

@interface Question : PFObject <PFSubclassing>

@property (nonatomic, copy) NSString *text;
@property (nonatomic, strong) Trait *trait;

@end
