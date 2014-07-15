//
//  CLModel.m
//  CharacterLab
//
//  Created by Pierpaolo Baccichet on 7/11/14.
//  Copyright (c) 2014 Dropbox. All rights reserved.
//

#import "CLModel.h"

@implementation CLModel

// Trait descriptions do not change (for now) and are small so we can safely cache them locally
static NSArray *sTraitDescriptions = nil;

+ (CLModel *)sharedInstance
{
    static dispatch_once_t once;
    static CLModel *instance = nil;
    dispatch_once(&once, ^ {
        instance = [[CLModel alloc] init];
    });
    return instance;
}

+ (void)setApplicationId:(NSString *)applicationId clientKey:(NSString *)clientKey {
    [Trait registerSubclass];
    [Question registerSubclass];
    [Student registerSubclass];
    [Teacher registerSubclass];
    [Assessment registerSubclass];
    [Tip registerSubclass];
    [Measurement registerSubclass];
    [Parse setApplicationId:applicationId clientKey:clientKey];

    // Pre-cache a few things at app startup to minimize latency when opening view controllers
    [[self sharedInstance] getTraitsWitSuccess:nil failure:nil];
}

- (void)getTraitsWitSuccess:(void (^)(NSArray *traitList))success
                    failure:(void (^)(NSError *error))failure
{
    if (sTraitDescriptions) {
        if (success) {
            success(sTraitDescriptions);
        }
    }

    [[Trait query] findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            if (failure) {
                failure(error);
            }
        }
        else {
            sTraitDescriptions = objects;
            if (success) {
                success(objects);
            }
        }
    }];
}

- (Trait *)getTraitForIndex:(NSInteger)traitIndex {
    // should be prepopulated
    return sTraitDescriptions[traitIndex];
}

- (void)getAssessmentsForMeasurement:(Measurement *)measurement
                             success:(void (^)(NSArray *assessmentList))success
                             failure:(void (^)(NSError *error))failure {
    PFQuery *query = [PFQuery queryWithClassName:@"Assessment"];
    [query whereKey:@"measurement" equalTo:measurement];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            failure(error);
        } else {
            success(objects);
        }
    }];
}

- (void)getMeasurementsForStudent:(Student *)student
                          success:(void (^)(NSArray *measurementsList))success
                          failure:(void (^)(NSError *error))failure {
    PFQuery *query = [PFQuery queryWithClassName:@"Measurement"];
    [query whereKey:@"student" equalTo:student];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            failure(error);
        } else {
            success(objects);
        }
    }];
}

- (void)getStudentsForCurrentTeacherWithSuccess:(void (^)(NSArray *studentList))success
                                        failure:(void (^)(NSError *error))failure {
    // TODO(rajeev/pier): filter by logged in teacher
    [[Student query] findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            failure(error);
        } else {
            success(objects);
        }
    }];
}

- (void)storeAssessmentForStudent:(Student *)student
                      measurement:(Measurement *)measurement
                            trait:(Trait *)trait
                            value:(NSInteger)score
                          failure:(void (^)(NSError *error))failure {

    Assessment *a = [[Assessment alloc] init];
    a.student = student;
    a.measurement = measurement;
    a.trait = trait;
    a.score = score;
    [a save]; // saving the assessment is synchronous for now
}

- (Measurement *)storeMeasurementForStudent:(Student *)student
                                      title:(NSString *)title
                                    failure:(void (^)(NSError *error))failure {
    Measurement *m = [[Measurement alloc] init];
    m.title = title;
    m.student = student;
    [m save]; // saving the measurement is synchronous for now
    return m;
}

- (void)updateLastMeasurementTSForStudent:(Student *)student
                                  failure:(void (^)(NSError *error))failure {
    student.lastAssessmentTS = [NSDate date];
    [student save]; // this operation is synchronous for now
}

- (void)getTipsForTrait:(Trait *)trait
                success:(void (^)(NSArray *tipsList))success
                failure:(void(^)(NSError *error))failure {
    PFQuery *query = [PFQuery queryWithClassName:@"Tip"];
    [query whereKey:@"trait" equalTo:trait];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            failure(error);
        } else {
            success(objects);
        }
    }];
}

@end
