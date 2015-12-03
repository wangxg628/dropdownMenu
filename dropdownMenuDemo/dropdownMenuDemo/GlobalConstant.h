//
//  GlobalConstant.h
//  AutoCARE
//
//  Created by 风往北吹_ on 15/11/2.
//  Copyright © 2015年 wangxg. All rights reserved.
//

#ifndef GlobalConstant_h
#define GlobalConstant_h


//自定义颜色 ColorWihtRGB(r,g,b,a) 和 ColorWihtRGBA(r,g,b) 
#define ColorWihtRGB(r,g,b,a) [UIColor  colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define ColorWihtRGBA(r,g,b) [UIColor  colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define ColorSeparatorLine   [UIColor  colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1.0]


//字体
#define TEXTFONT(r)   [UIFont fontWithName:@"Helvetica" size:r]

//获取屏幕 宽度、高度
#define SCREEN_WIDTH  ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define TEXTFONT(r)   [UIFont fontWithName:@"Helvetica" size:r]
#define TEXTBOLDFONT(r)  [UIFont boldSystemFontOfSize:r];
#define IsIOS7        ([[[UIDevice currentDevice] systemVersion] floatValue] >=7.0 ? YES : NO)
#define StatusBar           20
#define NavigationbarHeight 44
#define TopBarHeight        64
#define TabBarHeight        49

#endif /* GlobalConstant_h */
