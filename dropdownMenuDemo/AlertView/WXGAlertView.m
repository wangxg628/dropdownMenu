//
//  WXGAlertView.m
//  dropdownMenuDemo
//
//  Created by 风往北吹_ on 15/12/4.
//  Copyright © 2015年 wangxg. All rights reserved.
//

#import "WXGAlertView.h"

typedef void (^DoModalWindow)(WXGAlertView *alertView);

@interface WXGAlertView ()

@property (nonatomic, strong) DoModalWindow doModel;

@property (nonatomic, strong) UIView *contentView;

@end

@implementation WXGAlertView


- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        
        // 逐渐从中间变大
//        payTypeView.center = CGPointMake(SCREEN_WIDTH/2.0,0);
//        [UIView animateWithDuration:1 delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
//            payTypeView.center = CGPointMake(SCREEN_WIDTH/2.0,SCREEN_HEIGHT/2.0);
//        } completion:^(BOOL finished) {
//        }];
        
        _contentView = [[NSBundle mainBundle] loadNibNamed:@"payType" owner:nil options:nil].lastObject;
        _contentView.frame = CGRectMake((SCREEN_WIDTH-275)/2, (SCREEN_HEIGHT-148)/2, 275, 148);
        _contentView.layer.cornerRadius = 5.0f;
        [self addSubview:_contentView];
        
        _contentView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeWindow)];
        [_contentView addGestureRecognizer:tap];
    }
    return self;
}

-(void)showInView:(UIView *)baseView completion:(void (^)(WXGAlertView *alertView))completeBlock {
    
    self.doModel = completeBlock;
    [baseView addSubview:self];
    
//    _contentView.frame = CGRectMake(50, 150, 200, 150);
//    _contentView.alpha = 0;
//    _contentView.transform = CGAffineTransformMakeScale(0.01, 0.01);
//    
//    [UIView animateWithDuration:0.3f animations:^{
//        _contentView.alpha = 1.0;
//        _contentView.transform = CGAffineTransformMakeScale(1.0, 1.0);
//    }];
    
    // 从上面掉下来
    _contentView.center = CGPointMake(SCREEN_WIDTH/2.0,0);
    [UIView animateWithDuration:1 delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        _contentView.center = CGPointMake(SCREEN_WIDTH/2.0,SCREEN_HEIGHT/2.0);
    } completion:^(BOOL finished) {
    }];
}


/**
 *  显示弹出框
 */
-(void)showWindow:(void (^)(WXGAlertView *alertView))completeBlock {
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [self showInView:keyWindow completion:completeBlock];
}


/**
 *  关闭弹出框
 **/
-(void)closeWindow {
    
    [UIView animateWithDuration:0.15f animations:^{
        _contentView.center = CGPointMake(SCREEN_WIDTH/2.0,SCREEN_HEIGHT+300);
        self.alpha = 0;
//        _contentView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


@end
