//
//  BarGraphView.h
//  CharacterLab
//
//  Created by Pierpaolo Baccichet on 7/19/14.
//  Copyright (c) 2014 Dropbox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BarGraphView : UIView

- (void)drawGraphWithAnimation:(BOOL)animate
                assessmentList:(NSArray *)assessmentList;

@end
