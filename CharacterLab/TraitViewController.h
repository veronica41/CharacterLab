//
//  TraitViewController.h
//  CharacterLab
//
//  Created by Rajeev Nayak on 7/4/14.
//  Copyright (c) 2014 Dropbox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MultiPageViewController.h"
#import "CLModel.h"

@interface TraitViewController : UIViewController <MultiPageViewControllerChild>

@property (nonatomic, strong) Trait *trait;

@end
