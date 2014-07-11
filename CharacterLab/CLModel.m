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

- (void)getAssessmentsForStudent:(Student *)student
                         success:(void (^)(NSArray *assessmentList))success
                         failure:(void (^)(NSError *error))failure {
    PFQuery *query = [PFQuery queryWithClassName:@"Assessment"];
    [query whereKey:@"student" equalTo:student];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            failure(error);
        } else {
            // The find succeeded.
            success(objects);
        }
    }];
}

@end
