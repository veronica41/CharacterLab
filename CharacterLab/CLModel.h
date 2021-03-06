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

- (void)getAssessmentsForMeasurement:(Measurement *)measurement
                             success:(void (^)(NSArray *assessmentList))success
                             failure:(void (^)(NSError *error))failure;

- (void)getMeasurementsForStudent:(Student *)student
                         success:(void (^)(NSArray *measurementsList))success
                         failure:(void (^)(NSError *error))failure;

- (void)getStudentsForCurrentTeacherWithSuccess:(void (^)(NSArray *studentList))success
                                        failure:(void (^)(NSError *error))failure;

- (void)storeAssessmentForStudent:(Student *)student
                      measurement:(Measurement *)measurement
                            trait:(Trait *)trait
                            value:(NSInteger)score
                          failure:(void (^)(NSError *error))failure;

- (Measurement *)storeMeasurementForStudent:(Student *)student
                                      title:(NSString *)title
                                    failure:(void (^)(NSError *error))failure;

- (void)updateStudent:(Student *)student
          measurement:(Measurement *)measurement
              failure:(void (^)(NSError *error))failure;

- (void)getTipsForTrait:(Trait *)trait
                success:(void (^)(NSArray *tipsList))success
                failure:(void(^)(NSError *error))failure;

- (void)getLatestMeasurementForStudent:(Student *)student
                               success:(void (^)(Measurement *measurement))success
                               failure:(void (^)(NSError *error))failure;

- (void)getLowestScoringTraitsForAssessment:(NSArray *)assessmentList
                                      limit:(NSInteger)limit
                                    success:(void (^)(NSArray *traitList))success
                                    failure:(void (^)(NSError *error))failure;

- (void)getAssessmentForMeasurement:(Measurement *)measurement
                              trait:(Trait *)trait
                            success:(void (^)(Assessment * assessment))success
                            failure:(void (^)(NSError *error))failure;

@end
