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
    CLColorAquamarine      = 0X18B8B8,
    CLColorPurpleMountains = 0X5E58A2,
    CLColorGreenGrass      = 0X99B858,
    CLColorTelescopeBlue   = 0X168ECD,
    CLColorBlastOffRed     = 0XF2754D,
    CLColorGray            = 0X222A2A,
    CLColorDarkGrey        = 0X1F2626,
    CLColorHighlightGrey   = 0X3D4747,
    CLColorBackgroundGrey  = 0X2D3838,
    CLColorShadowGrey      = 0X252E2E,
    CLColorFlipGrey        = 0X151A1A,
    CLColorBackgroundBeige = 0XF5F2E0,
    CLColorShadowBeige     = 0XE8E5D3,
    CLColorSubtextBrown    = 0X8F8E8B,
    CLColorTextBrown       = 0X68665D,
    CLColorNoNoRed         = 0XF25B4D
} CLColorEnum;

#endif
