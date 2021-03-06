//
//  XYReadViewController.m
//  XYNetEasyNews
//
//  Created by 李小亚 on 16/5/15.
//  Copyright © 2016年 李小亚. All rights reserved.
//

#import "XYReadViewController.h"
#import "XYSegmentControl.h"

@interface XYReadViewController ()<XYSegmentControlDelegate>

@end

@implementation XYReadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //设置导航栏上的控件
    [self setupNavView];
}

//设置导航栏上的控件
- (void)setupNavView{
    XYSegmentControl *segmentCtr = [[XYSegmentControl alloc] initWithFrame:CGRectMake(10, 70, 200, 35)];
    segmentCtr.items = @[@"推荐订阅", @"我的订阅"];
    segmentCtr.height = 30;
    segmentCtr.delegate = self;
    self.navigationItem.titleView = segmentCtr;
    
    
    //右边边的UIBarButtonItem
    UIButton *rightBtn = [UIButton buttonWithNormalImage:[UIImage imageNamed:@"top_navigation_readerplus"] highlightedImage:[UIImage imageNamed:@"top_navigation_readerplus_highlighted"] target:self selcetor:@selector(rightBtnClick) controlEvent:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
}


- (void)rightBtnClick{
    
}
#pragma mark - XYSegmentControlDelegate
- (void)segmentControl:(XYSegmentControl *)segmentControl didClickBtnAtIndex:(NSInteger)index{
    XYLog(@"%ld", index);
}
@end
