//
//  DropdownButton.h
//  WXGTableView
//
//  Created by 风往北吹_ on 15/11/30.
//  Copyright © 2015年 wangxg. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DropdownButtonDelegate <NSObject>

- (void)showDropdownMenu:(NSInteger)index;
- (void)hideDropdownMenu;

@end

@interface DropdownButton : UIView

@property (nonatomic, weak) id<DropdownButtonDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame WithDropdownButtonTitles:(NSArray *)titles;

- (void)selectedItemIndex:(NSInteger)index title:(NSString *)title;

@end
