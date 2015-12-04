//
//  UIButton+horizLayout.m
//  dropdownMenuDemo
//
//  Created by 风往北吹_ on 15/12/4.
//  Copyright © 2015年 wangxg. All rights reserved.
//

#import "UIButton+horizLayout.h"

@implementation UIButton (horizLayout)

+ (instancetype)customButtonWithType:(WXGButtonType)buttonType {
    
    UIButton *customButton = [[UIButton alloc] init];
    return customButton;
    
    
//    float width = cgrectgetw;
//    float offsetX = width * index;
//    _image = [UIImage imageNamed:@"expandableImage"];
//    float padding = (width - (_image.size.width + [title sizeWithFont:[UIFont systemFontOfSize:13.0f]].width)) / 2;
//    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(offsetX, 0, width, BUTTON_HEIGHT)];
//    button.tag = 10000 + index;
//    [button setImage:_image forState:UIControlStateNormal];
//    [button setImageEdgeInsets:UIEdgeInsetsMake(11, [title sizeWithFont:[UIFont systemFontOfSize:13.0f]].width + padding + 5, 11, 0)];
//    [button.titleLabel setFont:[UIFont systemFontOfSize:13.0f]];
//    [button setTitle:title forState:UIControlStateNormal];
//    [button setTitleEdgeInsets:UIEdgeInsetsMake(11, 0, 11, _image.size.width + 5)];
//    [button setBackgroundColor:[UIColor whiteColor]];
//    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(showMenuAction:) forControlEvents:UIControlEventTouchUpInside];
//    return button;

}

@end
