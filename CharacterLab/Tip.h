//
//  Tips.h
//  CharacterLab
//
//  Created by Veronica Zheng on 7/13/14.
//  Copyright (c) 2014 Dropbox. All rights reserved.
//

#import <Parse/Parse.h>
#import "Trait.h"

@interface Tip : PFObject <PFSubclassing>

@property (nonatomic, copy) NSString *summary;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, strong) Trait *trait;

@end