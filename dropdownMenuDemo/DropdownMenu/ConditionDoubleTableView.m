//
//  ConditionDoubleTableView.m
//  WXGTableView
//
//  Created by 风往北吹_ on 15/11/30.
//  Copyright © 2015年 wangxg. All rights reserved.
//

#import "ConditionDoubleTableView.h"

#define tag_HandleImage        1001
#define tag_HandlebottomLine   1002

static NSString *const leftTableViewCellID = @"leftTableViewCellIdentifider";
static NSString *const rightTableViewCellID = @"rightTableViewCellIdentifider";

static CGFloat const duration = 0.35;
static CGFloat const handleHeight = 18;
static CGFloat const cellWithHeight = 44.0;

static NSInteger const minRowCount = 3;
static NSInteger const maxRowCount = 8;

@interface ConditionDoubleTableView ()<UITableViewDataSource,UITableViewDelegate> {

    CGRect m_Frame;
    NSInteger m_selectedIndex;
    BOOL m_isHidden;
    CGFloat totalHeight;
    NSInteger firstSelectedIndex;
    NSInteger secondSelectedIndex;
    
    NSInteger clickIndex;
}

// 数据
@property (nonatomic, strong) NSArray *showItems;
@property (nonatomic, strong) NSArray *leftArray;
@property (nonatomic, strong) NSArray *rightItems;
@property (nonatomic, strong) NSArray *rightArray;

// 控件
@property (nonatomic, strong) UIView *handleView;
@property (nonatomic, strong) UITableView *firstTableView;
@property (nonatomic, strong) UITableView *secondTableView;

@end

@implementation ConditionDoubleTableView

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super init];
    if (self) {
        m_Frame = frame;
        m_selectedIndex = -1;
        m_isHidden = YES;
        totalHeight = 0;
        
        firstSelectedIndex = 0;
        secondSelectedIndex = 0;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.frame = CGRectMake(0, m_Frame.size.height, m_Frame.size.width, totalHeight);
    self.view.clipsToBounds = YES;
    
    [self.view addSubview:self.firstTableView];
    [self.view addSubview:self.secondTableView];
    [self.view addSubview:self.handleView];
    
    [self showAndHideList:YES];
}

- (void)showAndHideList:(BOOL)status {
    
    self.view.hidden = status;
    m_isHidden = status;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"hideMenu" object:nil];
}


#pragma mark - Public Methods

- (void)showTableView:(NSInteger)index withShowItems:(NSArray *)showItems WithSelected:(NSString *)selected {
    _showItems = showItems;
    
    if (m_isHidden == YES || m_selectedIndex != index) {
        
        m_selectedIndex = index;
        [self showAndHideList:NO];
        [self p_hideList];
        [self showLastSelectedLeft:selected];
        
        [UIView animateWithDuration:duration animations:^{
            [self p_showList];
        }];
    } else {
        [self hideTableView];
    }
}

- (void)hideTableView {

[UIView animateWithDuration:duration animations:^{
    [self p_hideList];
} completion:^(BOOL finish){
    [self showAndHideList:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hideMenu"
                                                        object:[NSString stringWithFormat:@"%li",(long)m_selectedIndex]];
}];
}


#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ([tableView isEqual:_firstTableView]) {
        return _leftArray.count;
    } else if ([tableView isEqual:_secondTableView]) {
        return _rightArray.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    if ([tableView isEqual:_firstTableView]) {
        
        cell = [tableView dequeueReusableCellWithIdentifier:leftTableViewCellID];
        cell.textLabel.text = _leftArray[indexPath.row];
        
        cell.textLabel.font = TEXTFONT(13);
        cell.textLabel.textColor = ColorWihtRGBA(68, 68, 68);

        UIView *selectView = [[UIView alloc] initWithFrame:cell.contentView.bounds];
        selectView.backgroundColor = ColorWihtRGBA(243, 243, 243);
        cell.selectedBackgroundView = selectView;
        cell.backgroundColor = ColorWihtRGBA(235, 235, 235);
        
    } else if ([tableView isEqual:_secondTableView]) {
        
        cell = [tableView dequeueReusableCellWithIdentifier:rightTableViewCellID];
        cell.textLabel.text = _rightArray[indexPath.row];

        cell.textLabel.font = TEXTFONT(13);
        cell.textLabel.textColor = ColorWihtRGBA(68, 68, 68);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (secondSelectedIndex == indexPath.row && firstSelectedIndex == clickIndex) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            cell.tintColor = [UIColor redColor];
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([tableView isEqual:_firstTableView]) {

        if (_rightItems != nil && _rightItems.count > 0) {
            _rightArray = _rightItems[indexPath.row];
            clickIndex = indexPath.row;
            [_secondTableView reloadData];
        } else {
            firstSelectedIndex = 0;
            [self p_returnSelectedValue:indexPath.row];
            [_firstTableView reloadData];
        }
        
    } else if ([tableView isEqual:_secondTableView]) {
        firstSelectedIndex = clickIndex;
        secondSelectedIndex = indexPath.row;
        [self p_returnSelectedValue:indexPath.row];
        [_secondTableView reloadData];
    }
}

// cell的分割线左侧补齐

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}


#pragma mark - private Methods

- (void)p_layoutLeft:(NSInteger)cellRowCount {
    
    // 列表
    totalHeight = cellWithHeight * cellRowCount;
    _secondTableView.frame = CGRectMake(0, 0, m_Frame.size.width, totalHeight);
    
    // 把手
    _handleView.frame = CGRectMake(0, totalHeight, m_Frame.size.width, handleHeight);
    UIImageView *handleImage = (UIImageView *)[_handleView viewWithTag:tag_HandleImage];
    handleImage.frame = CGRectMake(_handleView.frame.size.width/2-8, 5, 16, 8);

    UIView *handleBottomLine = [_handleView viewWithTag:tag_HandlebottomLine];
    handleBottomLine.frame = CGRectMake(0, CGRectGetHeight(_handleView.frame)-1, SCREEN_WIDTH, 1);
    
    // 背景视图
    totalHeight += handleHeight;
}

- (void)p_layoutRight:(NSInteger)cellRowCount {
    
    // 列表
    totalHeight = cellWithHeight * cellRowCount;
    _firstTableView.frame = CGRectMake(0, 0, m_Frame.size.width/2, totalHeight);
    _secondTableView.frame = CGRectMake(m_Frame.size.width/2, 0, m_Frame.size.width/2, totalHeight);
    
    // 把手
    _handleView.frame = CGRectMake(0, totalHeight, m_Frame.size.width, handleHeight);
    UIImageView *handleImage = (UIImageView *)[_handleView viewWithTag:tag_HandleImage];
    handleImage.frame = CGRectMake(_handleView.frame.size.width/2-8, 5, 16, 8);
    
    UIView *handleBottomLine = [_handleView viewWithTag:tag_HandlebottomLine];
    handleBottomLine.frame = CGRectMake(0, CGRectGetHeight(_handleView.frame)-1, SCREEN_WIDTH, 1);
    
    // 背景视图
    totalHeight += handleHeight;
}

- (void)p_showList {
    self.view.frame = CGRectMake(0, m_Frame.size.height, m_Frame.size.width, totalHeight);
}

- (void)p_hideList {
    
    _leftArray = nil;
    _rightItems = nil;
    _rightArray = nil;
    
    if (_showItems.count == 1) {            // 不显示二级菜单(因为没有数据)
        
        _firstTableView.hidden = YES;
        _rightArray = _showItems[0];
        
        if (_rightArray.count > minRowCount && _rightArray.count < maxRowCount) {
            [self p_layoutLeft:_rightArray.count];
        } else if (_rightArray.count <= minRowCount) {
            [self p_layoutLeft:minRowCount];
        } else if (_rightArray.count >= maxRowCount) {
            [self p_layoutLeft:maxRowCount];
        }
        [_secondTableView reloadData];
    } else if (_showItems.count == 2) {     // 显示二级级菜单
        
        _firstTableView.hidden = NO;
        _leftArray = _showItems[0];
        _rightItems = _showItems[1];
        
        if (_leftArray.count > minRowCount && _leftArray.count < maxRowCount) {
            [self p_layoutRight:_leftArray.count];
        } else if (_leftArray.count <= minRowCount) {
            [self p_layoutRight:minRowCount];
        } else if (_leftArray.count >= maxRowCount) {
            [self p_layoutRight:maxRowCount];
        }
        [_firstTableView reloadData];
    }
    
    self.view.frame = CGRectMake(0, m_Frame.size.height, m_Frame.size.width, 0);
}

//返回选中位置
- (void)p_returnSelectedValue:(NSInteger)index {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectedFirstValues:withTitle:)]) {
        NSInteger firstSelected = firstSelectedIndex > 0 ? firstSelectedIndex : 0;
        NSString *firstIndex = [NSString stringWithFormat:@"%li", (long)firstSelected];
        NSString *indexObj = [NSString stringWithFormat:@"%ld", (long)index];
        NSArray *values = @[firstIndex,indexObj];
        NSString *title = _rightArray[index];
        [self.delegate performSelector:@selector(selectedFirstValues:withTitle:) withObject:values withObject:title];
        [self hideTableView];
    }
}

//显示最后一次选中位置
- (void)showLastSelectedLeft:(NSString *)selected {
    
    NSArray *selectedArray = [selected componentsSeparatedByString:@"-"];
    NSString *left = [selectedArray objectAtIndex:0];
    NSString *right = [selectedArray objectAtIndex:1];
    
    NSInteger leftIndex = [left intValue];
    firstSelectedIndex = leftIndex;
    
    NSInteger rightIndex = [right intValue];
    secondSelectedIndex = rightIndex;
}


#pragma mark - getter and setter

- (UITableView *)firstTableView {
    
    if (!_firstTableView) {
        _firstTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _firstTableView.backgroundColor = ColorWihtRGBA(243, 243, 243);
        _firstTableView.dataSource = self;
        _firstTableView.delegate = self;
        _firstTableView.tableFooterView = [[UIView alloc] init];
        [_firstTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:leftTableViewCellID];
    }
    return _firstTableView;
}

- (UITableView *)secondTableView {
    
    if (!_secondTableView) {
        _secondTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _secondTableView.backgroundColor = [UIColor whiteColor];
        _secondTableView.dataSource = self;
        _secondTableView.delegate = self;
        _secondTableView.tableFooterView = [[UIView alloc] init];
        [_secondTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:rightTableViewCellID];
    }
    return _secondTableView;
}

- (UIView *)handleView {
    
    if (!_handleView) {
        _handleView = [[UIView alloc] init];
        _handleView.backgroundColor = [UIColor whiteColor];
        _handleView.layer.shadowOpacity = YES;
        _handleView.layer.shadowColor = ColorWihtRGBA(235, 235, 235).CGColor;
        
        UIImageView *handle = [[UIImageView alloc] init];
        handle.tag = tag_HandleImage;
        handle.image = [UIImage imageNamed:@"下拉icon"];
        [_handleView addSubview:handle];
        
        UIView *bottomLine = [[UIView alloc] init];
        bottomLine.tag = tag_HandlebottomLine;
        bottomLine.backgroundColor = ColorWihtRGBA(235, 235, 235);
        [_handleView addSubview:bottomLine];
    }
    return _handleView;
}

@end
