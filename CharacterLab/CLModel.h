//
//  CLModel.h
//  CharacterLab
//
//  Created by Pierpaolo Baccichet on 7/11/14.
//  Copyright (c) 2014 Dropbox. All rights reserved.
//
//  Wrapper class used to import all model code and provide a singleton
//  object for caching/querying data related to CharacterLab entities
//  (students, assessments, etc).

#import <Foundation/Foundation.h>
#import "Trait.h"
#import "Question.h"
#import "Student.h"
#import "Teacher.h"
#import "Assessment.h"

@interface CLModel : NSObject

// Initialize global app ID and consumer keys
+ (void)setApplicationId:(NSString *)applicationId clientKey:(NSString *)clientKey;
+ (CLModel *)sharedInstance;

- (void)getTraitsWitSuccess:(void (^)(NSArray *traitList))success
                    failure:(void (^)(NSError *error))failure;

- (void)getAssessmentsForStudent:(Student *)student
                         success:(void (^)(NSArray *assessmentList))success
                         failure:(void (^)(NSError *error))failure;

- (void)getStudentsForCurrentTeacherWithSuccess:(void (^)(NSArray *studentList))success
                                        failure:(void (^)(NSError *error))failure;

- (void)storeAssessmentForStudent:(Student *)student
                            trait:(Trait *)trait
                            value:(CLAssessmentScore)score
                          failure:(void (^)(NSError *error))failure;

@end