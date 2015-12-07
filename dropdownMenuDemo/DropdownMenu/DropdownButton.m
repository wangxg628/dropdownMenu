//
//  DropdownButton.m
//  WXGTableView
//
//  Created by 风往北吹_ on 15/11/30.
//  Copyright © 2015年 wangxg. All rights reserved.
//

#import "DropdownButton.h"
#import "DropdownItem.h"

static NSInteger const buttonTag = 1000;
static NSInteger const buttonCount = 3;
static CGFloat const   buttonHeight = 40;
static CGFloat const   separatorLineWidth = 1;

@interface DropdownButton () {

    NSInteger   m_lastTap;
}

@property (nonatomic, strong) NSArray *titles;

@property (nonatomic, strong) NSString *lastTapObj;

@end

@implementation DropdownButton

- (instancetype)initWithFrame:(CGRect)frame WithDropdownButtonTitles:(NSArray *)titles {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor yellowColor];
        m_lastTap = -1;   //最大值，未选择状态
        
        //  menuItem
        for (int index = 0; index <buttonCount; ++index) {
            CGFloat itemWidth = CGRectGetWidth(self.frame)/buttonCount;
            CGRect itemFrame = CGRectMake(index *itemWidth, 0, itemWidth, CGRectGetHeight(self.frame));
            UIImage *image = [UIImage imageNamed:@"mark1"];
            DropdownItem *button = [[DropdownItem alloc] initWithFrame:itemFrame andTitle:titles[index] andImage:image];
            button.tag = buttonTag + index;
            [button addTarget:self action:@selector(onShowMenuAction:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
        }

        //separatorLine
        for (int index = 1; index < buttonCount; ++index) {
            CGFloat dropdownBtnWidth = CGRectGetWidth(self.frame)/buttonCount;
            CGRect BFrame = CGRectMake(index *dropdownBtnWidth, 0, separatorLineWidth, buttonHeight);
            UIView *separatorLine = [[UIView alloc] initWithFrame:BFrame];
            separatorLine.backgroundColor = ColorWihtRGBA(235, 235, 235);
            [self addSubview:separatorLine];
        }
        
        // bottomSeparatorLine
        UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, buttonHeight-1, SCREEN_WIDTH, 1)];
        bottomLine.backgroundColor = ColorWihtRGBA(235, 235, 235);
        [self addSubview:bottomLine];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideMenu:) name:@"hideMenu" object:_lastTapObj];
    }
    return self;
}

- (void)selectedItemIndex:(NSInteger)index title:(NSString *)title {
    
    DropdownItem *item = (DropdownItem *)[self viewWithTag:index + buttonTag];
    item.titleLabel.text = title;
}


#pragma mark - event response

- (void)onShowMenuAction:(UIControl *)sender {
    
    NSInteger index = sender.tag;
    
    if (m_lastTap != index) {
        if (m_lastTap >= 0) {
            [self changeButtionTag:m_lastTap Rotation:0];
        }
        m_lastTap = index;
        [self changeButtionTag:index Rotation:M_PI];
        if ([self.delegate respondsToSelector:@selector(showDropdownMenu:)]) {
            [self.delegate showDropdownMenu:index - buttonTag];
        }
        
    } else {
        [self changeButtionTag:m_lastTap Rotation:0];
        m_lastTap = -1;     // 恢复到未选择状态
        if ([self.delegate respondsToSelector:@selector(hideDropdownMenu)]) {
            [self.delegate hideDropdownMenu];
        }
    }

}

- (void)hideMenu:(NSNotification *)notification {
    _lastTapObj = [notification object];
    [self changeButtionTag:([_lastTapObj intValue] + buttonTag) Rotation:0];
    m_lastTap = -1;  // 恢复到未选择状态
}


- (void)changeButtionTag:(NSInteger)index Rotation:(CGFloat)angle {
    
    [UIView animateWithDuration:0.1f animations:^{
        DropdownItem *item = (DropdownItem *)[self viewWithTag:index];
        item.imageView.transform = CGAffineTransformMakeRotation(angle);
        if (angle == 0) {
            [item.titleLabel setTextColor:ColorWihtRGBA(68, 68, 68)];
            [item.imageView setImage:[UIImage imageNamed:@"mark1"]];
        } else {
            [item.titleLabel setTextColor:ColorWihtRGBA(255, 128, 0)];
            [item.imageView setImage:[UIImage imageNamed:@"mark2"]];
        }
    }];
}


@end
