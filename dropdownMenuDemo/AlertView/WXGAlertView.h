//
//  WXGAlertView.h
//  dropdownMenuDemo
//
//  Created by 风往北吹_ on 15/12/4.
//  Copyright © 2015年 wangxg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WXGAlertView : UIView


-(void)showWindow:(void (^)(WXGAlertView *alertView))completeBlock;

-(void)showInView:(UIView *)baseView completion:(void (^)(WXGAlertView *alertView))completeBlock;

@end
