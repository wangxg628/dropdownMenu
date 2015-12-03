//
//  ViewController.m
//  dropdownMenuDemo
//
//  Created by 风往北吹_ on 15/12/3.
//  Copyright © 2015年 wangxg. All rights reserved.
//

#import "ViewController.h"
#import "DropdownMenu.h"

@interface ViewController ()<DropdownMenuDelegate>

@property (nonatomic, strong) DropdownMenu *dropdownMenu;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"下拉菜单";
    self.view.backgroundColor = [UIColor yellowColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, 150, 150, 35)];
    label.userInteractionEnabled = YES;
    [self.view addSubview:label];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClick)];
    [label addGestureRecognizer:tap];
    
    NSArray *leftItem1 = @[@"全部",@"易车生活洗车",@"店面代金券",@"人工普洗",@"人工精洗",@"电脑普洗",@"电脑精洗"];
    NSArray *leftItem2 = @[@"全部",@"通用品牌",@"现代专用"];
    NSArray *leftItem3 = @[@"全部",@"通用品牌",@"索菲玛"];
    NSArray *leftItem4 = @[@"全部",@"车仆",@"标榜",@"3M",@"通用品牌"];
    NSArray *leftItem5 = @[@"全部",@"清洗节气门",@"清洗三元催化器",@"清洗喷油嘴",@"清洗进气道"];
    NSArray *leftItem6 = @[@"全部",@"通用品牌"];
    NSArray *leftItem7 = @[@"全部",@"通用品牌",@"清洗节气门",@"清洗三元催化器"];
    
    NSArray *lRightItem = @[leftItem1,leftItem2,leftItem3,leftItem4,leftItem5,leftItem6,leftItem7];
    NSArray *leftItems = [[NSArray alloc] initWithObjects:leftItem1,lRightItem, nil];
    
    NSArray *centerItem1 = @[@"默认排序",@"价格最低",@"距离最近",@"成交最多",@"评分最高",@"优惠最大"];
    NSArray *centerItems = [[NSArray alloc] initWithObjects:centerItem1, nil];
    
    NSArray *rightItem1 = @[@"全部",@"夜间营业",@"推荐商家"];
    NSArray *rightItems = [[NSArray alloc] initWithObjects:rightItem1, nil];
    
    NSArray *titles = @[@"人工普洗",@"智能排序",@"筛选"];
    
    NSArray *menuItems = @[leftItems,centerItems,rightItems];
    
    CGRect frame = CGRectMake(0, TopBarHeight, SCREEN_WIDTH, 40);
    _dropdownMenu = [[DropdownMenu alloc] initDropdownMenuWithFrame:frame Menutitles:titles MenuLists:menuItems];
    _dropdownMenu.delegate = self;
    [self.view addSubview:_dropdownMenu.view];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onClick {
    NSLog(@"可以相应点击事件");
}

- (void)dropdownSelectedLeftIndex:(NSString *)left RightIndex:(NSString *)right {
    NSLog(@"%@, %@", left, right);
}

@end
