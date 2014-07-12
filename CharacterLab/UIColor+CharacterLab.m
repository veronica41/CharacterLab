//
//  UIColor+CharacterLab.m
//  CharacterLab
//
//  Created by Veronica Zheng on 7/7/14.
//  Copyright (c) 2014 Dropbox. All rights reserved.
//

#import "UIColor+CharacterLab.h"

#define UIColorFromHEX(hexValue) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0xFF00) >> 8))/255.0 blue:  ((float)(hexValue & 0xFF))/255.0 alpha:1.0]

@implementation UIColor (CharacterLab)

+ (UIColor *)pencilYellowColor {
    static UIColor *pencilYellowColor = nil;
    if (!pencilYellowColor) {
        pencilYellowColor = [UIColor colorWithRed:255/255.0 green:221/255.0 blue:0/255.0 alpha:1.0];
    }
    return pencilYellowColor;
}

+ (UIColor *)aquamarineColor {
    static UIColor *aquamarineColor = nil;
    if (!aquamarineColor) {
        aquamarineColor = [UIColor colorWithRed:0/255.0 green:204/255.0 blue:204/255.0 alpha:1.0];
    }
    return aquamarineColor;
}

+ (UIColor *)purpleMountainsColor {
    static UIColor *purpleMountainColor = nil;
    if (!purpleMountainColor) {
        purpleMountainColor = [UIColor colorWithRed:94/255.0 green:88/255.0 blue:162/255.0 alpha:1.0];
    }
    return purpleMountainColor;
}

+ (UIColor *)greenGrassColor {
    static UIColor *greenGlassColor = nil;
    if (!greenGlassColor) {
        greenGlassColor = [UIColor colorWithRed:178/255.0 green:212/255.0 blue:206/255.0 alpha:1.0];
    }
    return greenGlassColor;
}

+ (UIColor *)telescopeBlueColor {
    static UIColor *telescopeBlueColor = nil;
    if (!telescopeBlueColor) {
        telescopeBlueColor = [UIColor colorWithRed:22/255.0 green:142/255.0 blue:205/255.0 alpha:1.0];
    }
    return telescopeBlueColor;
}

+ (UIColor *)blastOffRedColor {
    static UIColor *blastOffRedColor = nil;
    if (!blastOffRedColor) {
        blastOffRedColor = [UIColor colorWithRed:242/255.0 green:117/255.0 blue:77/255.0 alpha:1.0];
    }
    return blastOffRedColor;
}

+ (UIColor *)CLBackgroundGrayColor {
    static UIColor *CLBackgroundGrayColor = nil;
    if (!CLBackgroundGrayColor) {
        CLBackgroundGrayColor = UIColorFromHEX(0X222A2A);
    }
    return CLBackgroundGrayColor;
}

+ (UIColor *)CLBackgroundDarkGrayColor {
    static UIColor *CLBackgroundDarkGrayColor = nil;
    if (!CLBackgroundDarkGrayColor) {
        CLBackgroundDarkGrayColor = UIColorFromHEX(0X1C2323);
    }
    return CLBackgroundDarkGrayColor;
}

+ (UIColor *)CLRedButtonColor {
    static UIColor *CLRedButtonColor = nil;
    if (!CLRedButtonColor) {
        CLRedButtonColor = UIColorFromHEX(0XF15B4D);
    }
    return CLRedButtonColor;
}

@end
