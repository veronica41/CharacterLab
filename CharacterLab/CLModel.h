//
//  CLModel.h
//  CharacterLab
//
//  Created by Pierpaolo Baccichet on 7/11/14.
//  Copyright (c) 2014 Dropbox. All rights reserved.
//
//  This is a wrapper class used to import all model code and provide a singleton
//  object for caching/querying data related to CharacterLab entities (students,
//  assessments, etc).

#import <Foundation/Foundation.h>
#import "Trait.h"
#import "Question.h"
#import "Student.h"
#import "Teacher.h"
#import "Assessment.h"

@interface CLModel : NSObject

+ (void)initWithApplicationId:(NSString *)applicationId clientKey:(NSString *)clientKey;

@end
