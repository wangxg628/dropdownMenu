//
//  DropdownMenu.m
//  WXGTableView
//
//  Created by 风往北吹_ on 15/11/30.
//  Copyright © 2015年 wangxg. All rights reserved.
//

#import "DropdownMenu.h"
#import "DropdownButton.h"
#import "ConditionDoubleTableView.h"

@interface DropdownMenu ()<DropdownButtonDelegate,ConditionDoubleTableViewDelegate> {
    CGRect m_frame;
}

@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray *menuItems;

@property (nonatomic, strong) NSMutableArray *btnIndexArray;
@property (nonatomic, assign) NSInteger btnSelectedIndex;

@property (nonatomic, strong) DropdownButton *dropdownButton;
@property (nonatomic, strong) ConditionDoubleTableView *showList;
@property (nonatomic, strong) UIView *mask;

@end

@implementation DropdownMenu

#pragma mark - life cycle

- (instancetype)initDropdownMenuWithFrame:(CGRect)frame Menutitles:(NSArray *)titles MenuLists:(NSArray *)menuItems {
    
    if (self = [super init]) {
        m_frame = frame;
        _titles = titles;
        _menuItems = menuItems;
        
        _btnSelectedIndex = -1;
        _btnIndexArray = [[NSMutableArray alloc] initWithCapacity:titles.count];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.frame = m_frame;
    
    [self.view addSubview:self.mask];
    [self.view addSubview:self.showList.view];
    [self.view addSubview:self.dropdownButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - DropdownButtonDelegate

- (void)showDropdownMenu:(NSInteger)index {

    if (index < _menuItems.count) {
        NSArray *showItems = _menuItems[index];
        
        _mask.hidden = NO;
        CGRect frame = self.view.frame;
        frame.size.height = SCREEN_HEIGHT-m_frame.origin.y;
        self.view.frame = frame;
        
        _btnSelectedIndex = index;
        NSString *selected = @"0-0";
        if (_btnIndexArray.count > index){
            selected = [_btnIndexArray objectAtIndex:_btnSelectedIndex];
        } else {
            [_btnIndexArray addObject:selected];
        }

        [_showList showTableView:index withShowItems:showItems WithSelected:selected];
    }
}

- (void)hideDropdownMenu {
    _mask.hidden = YES;
    self.view.frame = m_frame;
    [_showList hideTableView];
}


#pragma mark - ConditionDoubleTableViewDelegate 

- (void)selectedFirstValues:(NSArray *)values withTitle:(NSString *)title {
    
    [_dropdownButton selectedItemIndex:_btnSelectedIndex title:title];
    
    NSString *index = [NSString stringWithFormat:@"%@-%@", values[0], values[1]];
    [_btnIndexArray setObject:index atIndexedSubscript:_btnSelectedIndex];
    
    if (_delegate && [_delegate respondsToSelector:@selector(dropdownSelectedLeftIndex:RightIndex:)]) {
        [_delegate performSelector:@selector(dropdownSelectedLeftIndex:RightIndex:) withObject:values[0] withObject:values[1]];
        [self hideDropdownMenu];
    }
}


#pragma mark - getter and setter 

- (DropdownButton *)dropdownButton {
    
    if (!_dropdownButton) {
        // 按钮(创建放在后面，防止列表隐藏时覆盖)
        CGRect frame = CGRectMake(0, 0, m_frame.size.width, m_frame.size.height);
        _dropdownButton = [[DropdownButton alloc] initWithFrame:frame WithDropdownButtonTitles:_titles];
        _dropdownButton.delegate = self;
    }
    return _dropdownButton;
}

- (ConditionDoubleTableView *)showList {
    
    if (!_showList) {
        _showList = [[ConditionDoubleTableView alloc] initWithFrame:m_frame];
        _showList.delegate = self;
    }
    return _showList;
}

- (UIView *)mask {
    
    if (!_mask) {
        CGFloat maskHeight = SCREEN_HEIGHT - m_frame.origin.y;
        _mask = [[UIView alloc] initWithFrame:CGRectMake(0, 0, m_frame.size.width, maskHeight)];
        _mask.backgroundColor = [UIColor blackColor];
        _mask.alpha = 0.3;
        _mask.hidden = YES;
        [self.view addSubview:_mask];
        
        _mask.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideDropdownMenu)];
        [_mask addGestureRecognizer:tap];
    }
    return _mask;
}


@end
