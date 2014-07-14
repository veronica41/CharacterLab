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
#import "Measurement.h"
#import "Assessment.h"
#import "Tip.h"

@interface CLModel : NSObject

// Initialize global app ID and consumer keys
+ (void)setApplicationId:(NSString *)applicationId clientKey:(NSString *)clientKey;
+ (CLModel *)sharedInstance;

- (void)getTraitsWitSuccess:(void (^)(NSArray *traitList))success
                    failure:(void (^)(NSError *error))failure;

- (Trait *)getTraitForIndex:(NSInteger)traitIndex;

- (void)getAssessmentsForStudent:(Student *)student
                         success:(void (^)(NSArray *assessmentList))success
                         failure:(void (^)(NSError *error))failure;

- (void)getStudentsForCurrentTeacherWithSuccess:(void (^)(NSArray *studentList))success
                                        failure:(void (^)(NSError *error))failure;

- (void)storeAssessmentForStudent:(Student *)student
                      measurement:(Measurement *)measurement
                            trait:(Trait *)trait
                            value:(NSInteger)score
                          failure:(void (^)(NSError *error))failure;

- (Measurement *)storeMeasurementForStudent:(Student *)student
                       description:(NSString *)description
                           failure:(void (^)(NSError *error))failure;

- (void)updateLastMeasurementTSForStudent:(Student *)student
                                  failure:(void (^)(NSError *error))failure;

- (void)getTipsForTrait:(Trait *)trait
                success:(void (^)(NSArray *tipsList))success
                failure:(void(^)(NSError *error))failure;

@end
