//
//  UIButton+horizLayout.h
//  dropdownMenuDemo
//
//  Created by 风往北吹_ on 15/12/4.
//  Copyright © 2015年 wangxg. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,WXGButtonType) {
    
    WXGButtonTypeDefault,
    WXGButtonTypeHorizLayout
};

@interface UIButton (horizLayout)

+ (instancetype)customButtonWithType:(WXGButtonType)buttonType;

@end
