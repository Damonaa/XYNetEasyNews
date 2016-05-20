//
//  XYTopicsViewController.m
//  XYNetEasyNews
//
//  Created by 李小亚 on 16/5/15.
//  Copyright © 2016年 李小亚. All rights reserved.
//

#import "XYTopicsViewController.h"
#import "XYSegmentControl.h"

@interface XYTopicsViewController ()<XYSegmentControlDelegate>

@end

@implementation XYTopicsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航栏上的控件
    [self setupNavView];
}

//设置导航栏上的控件
- (void)setupNavView{
    XYSegmentControl *segmentCtr = [[XYSegmentControl alloc] initWithFrame:CGRectMake(10, 70, 200, 35)];
    segmentCtr.items = @[@"话题", @"问吧", @"关注"];
    segmentCtr.height = 30;
    segmentCtr.delegate = self;
    self.navigationItem.titleView = segmentCtr;
    //左边的UIBarButtonItem
    UIButton *leftBtn = [UIButton buttonWithNormalImage:[UIImage imageNamed:@"NBCJGZ_nav_search"] highlightedImage:[UIImage imageNamed:@"NBCJGZ_nav_search_highlighted"] target:self selcetor:@selector(leftBtnClick) controlEvent:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];

    //右边边的UIBarButtonItem
    UIButton *rightBtn = [UIButton buttonWithNormalImage:[UIImage imageNamed:@"top_navigation_readerplus"] highlightedImage:[UIImage imageNamed:@"top_navigation_readerplus_highlighted"] target:self selcetor:@selector(rightBtnClick) controlEvent:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    

}


- (void)leftBtnClick{
    
}
- (void)rightBtnClick{
    
}
#pragma mark - XYSegmentControlDelegate
- (void)segmentControl:(XYSegmentControl *)segmentControl didClickBtnAtIndex:(NSInteger)index{
    XYLog(@"%ld", index);
}
@end
