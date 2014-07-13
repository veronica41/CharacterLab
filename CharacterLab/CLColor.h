//
//  CLColor.h
//  CharacterLab
//
//  Created by Pierpaolo Baccichet on 7/12/14.
//  Copyright (c) 2014 Dropbox. All rights reserved.
//

#ifndef CharacterLab_CLColor_h
#define CharacterLab_CLColor_h

#define UIColorFromHEX(hexValue) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0xFF00) >> 8))/255.0 blue:  ((float)(hexValue & 0xFF))/255.0 alpha:1.0]

typedef enum : NSUInteger {
    CLColorPencilYellow    = 0XFFDD00,
    CLColorAquamarine      = 0X00CCCC,
    CLColorPurpleMountains = 0X5E58A2,
    CLColorGreenGrass      = 0XB2D4CE,
    CLColorTelescopeBlue   = 0X168ECD,
    CLColorBlastOffRed     = 0XF2754D,
    CLColorGray            = 0X222A2A,
    CLColorDarkGray        = 0X1C2323,
} CLColorEnum;

#endif
