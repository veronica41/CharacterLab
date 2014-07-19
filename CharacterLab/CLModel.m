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
            NSMutableArray *orderedArray = [NSMutableArray arrayWithArray:objects];
            [orderedArray sortUsingComparator:^NSComparisonResult(id a, id b) {
                NSInteger first = ((Trait*)a).order;
                NSInteger second = ((Trait*)b).order;
                return second < first;
            }];
            sTraitDescriptions = orderedArray;
            if (success) {
                success(orderedArray);
            }
        }
    }];
}

- (Trait *)getTraitForIndex:(NSInteger)traitIndex {
    // should be prepopulated
    return sTraitDescriptions[traitIndex];
}


- (void)getLowestScoringTraitsForAssessment:(NSArray *)assessmentList
                                      limit:(NSInteger)limit
                                    success:(void (^)(NSArray *traitList))success
                                    failure:(void (^)(NSError *error))failure {

    if (!assessmentList) {
        return;
    }

    NSMutableArray *orderedArray = [NSMutableArray arrayWithArray:assessmentList];
    [orderedArray sortUsingComparator:^NSComparisonResult(id a, id b) {
        NSInteger first = ((Assessment*)a).score;
        NSInteger second = ((Assessment*)b).score;
        return second < first;
    }];

    NSMutableArray *traitsToFetch = [NSMutableArray array];
    for (int i = 0 ; i < MIN(limit, orderedArray.count); i++) {
        Assessment *tmp = (Assessment *)[orderedArray objectAtIndex:i];
        [traitsToFetch addObject:tmp.trait];
    }

    [Trait fetchAllIfNeededInBackground:traitsToFetch block:^(NSArray *objects, NSError *error) {
        if (error) {
            failure(error);
        }
        else {
            success(objects);
        }
    }];
}

- (void)getAssessmentsForMeasurement:(Measurement *)measurement
                             success:(void (^)(NSArray *assessmentList))success
                             failure:(void (^)(NSError *error))failure {
    PFQuery *query = [PFQuery queryWithClassName:@"Assessment"];
    [query whereKey:@"measurement" equalTo:measurement];
    [query orderByAscending:@"score"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            failure(error);
        } else {
            success(objects);
        }
    }];
}

- (void)getAssessmentForMeasurement:(Measurement *)measurement
                              trait:(Trait *)trait
                            success:(void (^)(Assessment * assessment))success
                            failure:(void (^)(NSError *error))failure {
    PFQuery *query = [PFQuery queryWithClassName:@"Assessment"];
    [query whereKey:@"measurement" equalTo:measurement];
    [query whereKey:@"trait" equalTo:trait];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            failure(error);
        } else {
            if (objects.count == 1) {
                success(objects[0]);
            } else {
                success(nil);
            }
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

- (void)getLatestMeasurementForStudent:(Student *)student
                                        success:(void (^)(Measurement *measurement))success
                                        failure:(void (^)(NSError *error))failure {
    PFQuery *query = [PFQuery queryWithClassName:@"Measurement"];
    [query getObjectInBackgroundWithId:student.lastMeasurementID block:^(PFObject *object, NSError *error) {
        if (error) {
            failure(error);
        }
        else {
            success((Measurement *)object);
        }
    }];
}

- (void)updateStudent:(Student *)student
          measurement:(Measurement *)measurement
              failure:(void (^)(NSError *error))failure {
    student.lastAssessmentTS = [NSDate date];
    student.lastMeasurementID = measurement.objectId;
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
