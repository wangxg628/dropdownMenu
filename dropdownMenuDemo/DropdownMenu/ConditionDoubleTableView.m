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
}

// 数据
@property (nonatomic, strong) NSArray *showItems;
@property (nonatomic, strong) NSArray *leftArray;
@property (nonatomic, strong) NSArray *rightItems;
@property (nonatomic, strong) NSArray *rightArray;

// 控件
@property (nonatomic, strong) UIView *handleView;

@property (nonatomic, strong) UITableView *leftTableView;
@property (nonatomic, strong) UITableView *rightTableView;

@end

@implementation ConditionDoubleTableView

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super init];
    if (self) {
        m_Frame = frame;
        m_selectedIndex = -1;
        m_isHidden = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.frame = CGRectMake(0, m_Frame.size.height, m_Frame.size.width, 0);
    self.view.backgroundColor = [UIColor redColor];
    self.view.clipsToBounds = YES;
    
    [self setupDropdownList];
    
    [self showAndHideList:YES];
}

- (void)setupDropdownList {
    
    [self.view addSubview:self.leftTableView];
    [self.view addSubview:self.rightTableView];
    [self.view addSubview:self.handleView];
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

- (void)showTableView:(NSInteger)index withShowItems:(NSArray *)showItems {
    
    _showItems = nil;
    _leftArray = nil;
    _rightItems = nil;
    _rightArray = nil;
    
    _showItems = showItems;
    
    if (m_isHidden == YES || m_selectedIndex != index) {
        [self showAndHideList:NO];
        
        m_selectedIndex = index;

        [self p_hideList];
        
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
    
    if ([tableView isEqual:_leftTableView]) {
        return _leftArray.count;
    } else if ([tableView isEqual:_rightTableView]) {
        return _rightArray.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    if ([tableView isEqual:_leftTableView]) {
        
        cell = [tableView dequeueReusableCellWithIdentifier:leftTableViewCellID];
        cell.textLabel.text = _leftArray[indexPath.row];
        
        cell.textLabel.font = TEXTFONT(13);
        cell.textLabel.textColor = ColorWihtRGBA(68, 68, 68);

        UIView *selectView = [[UIView alloc] initWithFrame:cell.contentView.bounds];
        selectView.backgroundColor = ColorWihtRGBA(243, 243, 243);
        cell.selectedBackgroundView = selectView;
        cell.backgroundColor = ColorWihtRGBA(235, 235, 235);
        
    } else if ([tableView isEqual:_rightTableView]) {
        
        cell = [tableView dequeueReusableCellWithIdentifier:rightTableViewCellID];
        cell.textLabel.text = _rightArray[indexPath.row];
        
        cell.textLabel.font = TEXTFONT(13);
        cell.textLabel.textColor = ColorWihtRGBA(68, 68, 68);
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([tableView isEqual:_leftTableView]) {

        if (_rightItems != nil && _rightItems.count > 0) {
            _rightArray = _rightItems[indexPath.row];
            [_rightTableView reloadData];
        } else {
            [self p_returnSelectedValue:indexPath.row];
        }
        firstSelectedIndex = indexPath.row;
        
    } else if ([tableView isEqual:_rightTableView]) {
        [self p_returnSelectedValue:indexPath.row];
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
    _leftTableView.frame = CGRectMake(0, 0, m_Frame.size.width, totalHeight);
    
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
    _leftTableView.frame = CGRectMake(0, 0, m_Frame.size.width/2, totalHeight);
    _rightTableView.frame = CGRectMake(m_Frame.size.width/2, 0, m_Frame.size.width/2, totalHeight);
    
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
    
    if (_showItems.count == 1) {
        
        _rightTableView.hidden = YES;
        _leftArray = _showItems[0];
        
        if (_leftArray.count > minRowCount && _leftArray.count < maxRowCount) {
            [self p_layoutLeft:_leftArray.count];
        } else if (_leftArray.count <= minRowCount) {
            [self p_layoutLeft:minRowCount];
        } else if (_leftArray.count >= maxRowCount) {
            [self p_layoutLeft:maxRowCount];
        }
        [_leftTableView reloadData];
        
    } else if (_showItems.count == 2) {
        
        _rightTableView.hidden = NO;
        _leftArray = _showItems[0];
        _rightItems = _showItems[1];
        
        if (_leftArray.count > minRowCount && _leftArray.count < maxRowCount) {
            [self p_layoutRight:_leftArray.count];
        } else if (_leftArray.count <= minRowCount) {
            [self p_layoutRight:minRowCount];
        } else if (_leftArray.count >= maxRowCount) {
            [self p_layoutRight:maxRowCount];
        }
    }
    
    self.view.frame = CGRectMake(0, m_Frame.size.height, m_Frame.size.width, 0);
}

//返回选中位置
- (void)p_returnSelectedValue:(NSInteger)index {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectedFirstValue:SecondValue:)]) {
        NSInteger firstSelected = firstSelectedIndex > 0 ? firstSelectedIndex : 0;
        NSString *firstIndex = [NSString stringWithFormat:@"%ld", firstSelected];
        NSString *indexObj = [NSString stringWithFormat:@"%ld", (long)index];
        [self.delegate performSelector:@selector(selectedFirstValue:SecondValue:) withObject:firstIndex withObject:indexObj];
        [self hideTableView];
    }
}



#pragma mark - getter and setter

- (UITableView *)leftTableView {
    
    if (!_leftTableView) {
        _leftTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _leftTableView.backgroundColor = ColorWihtRGBA(243, 243, 243);
        _leftTableView.dataSource = self;
        _leftTableView.delegate = self;
        _leftTableView.tableFooterView = [[UIView alloc] init];
        [_leftTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:leftTableViewCellID];
    }
    return _leftTableView;
}

- (UITableView *)rightTableView {
    
    if (!_rightTableView) {
        _rightTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _rightTableView.backgroundColor = [UIColor whiteColor];
        _rightTableView.dataSource = self;
        _rightTableView.delegate = self;
        _rightTableView.tableFooterView = [[UIView alloc] init];
        [_rightTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:rightTableViewCellID];
    }
    return _rightTableView;
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
