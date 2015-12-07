//
//  ConditionDoubleTableView.h
//  WXGTableView
//
//  Created by 风往北吹_ on 15/11/30.
//  Copyright © 2015年 wangxg. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ConditionDoubleTableViewDelegate <NSObject>

@required
- (void)selectedFirstValues:(NSArray *)values withTitle:(NSString *)title;
@end


@interface ConditionDoubleTableView : UIViewController

@property (nonatomic, weak) id<ConditionDoubleTableViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame;

- (void)showTableView:(NSInteger)index withShowItems:(NSArray *)showItems WithSelected:(NSString *)selected;
- (void)hideTableView;

@end
