//
//  CLModel.m
//  CharacterLab
//
//  Created by Pierpaolo Baccichet on 7/11/14.
//  Copyright (c) 2014 Dropbox. All rights reserved.
//

#import "CLModel.h"

@implementation CLModel

+ (void)initWithApplicationId:(NSString *)applicationId clientKey:(NSString *)clientKey {
    [Trait registerSubclass];
    [Question registerSubclass];
    [Student registerSubclass];
    [Teacher registerSubclass];
    [Assessment registerSubclass];
    [Parse setApplicationId:applicationId clientKey:clientKey];
}

@end
