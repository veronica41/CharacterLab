//
//  Trait.h
//  CharacterLab
//
//  Created by Rajeev Nayak on 7/3/14.
//  Copyright (c) 2014 Dropbox. All rights reserved.
//

#import <Parse/Parse.h>

@interface Trait : PFObject <PFSubclassing>

@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) NSString *description;
@property (nonatomic, copy, readonly) NSURL *imageUrl;

@end
