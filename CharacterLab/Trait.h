//
//  Trait.h
//  CharacterLab
//
//  Created by Rajeev Nayak on 7/3/14.
//  Copyright (c) 2014 Dropbox. All rights reserved.
//

#import <Parse/Parse.h>

#define NUM_TRAITS 7

@interface Trait : PFObject <PFSubclassing>

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, copy) NSString *videoUrl;
@property (nonatomic, assign) NSInteger order;
@property (nonatomic, copy) NSString *suggestion1;
@property (nonatomic, copy) NSString *suggestion2;
@property (nonatomic, copy) NSString *suggestion3;

@end
