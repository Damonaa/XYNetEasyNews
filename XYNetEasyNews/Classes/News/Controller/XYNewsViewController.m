//
//  XYNewsViewController.m
//  XYNetEasyNews
//
//  Created by 李小亚 on 16/5/15.
//  Copyright © 2016年 李小亚. All rights reserved.
//

#import "XYNewsViewController.h"
#import "XYRightButton.h"
#import "XYSearchViewController.h"
#import "XYSubsView.h"
#import "XYAddSubsView.h"
#import "XYSubsChannelView.h"
#import "XYSortDelView.h"
#import "XYSubsTool.h"

@interface XYNewsViewController ()
/**
 *  已经订阅的频道的滚动视图
 */
@property (nonatomic, weak) XYSubsView *subsView;
/**
 *  右边的UIBarButtonItem
 */
@property (nonatomic, weak) XYRightButton *rightBtn;
/**
 *  添加订阅按钮
 */
@property (nonatomic, weak) UIButton *addBtn;
/**
 *  添加频道视图
 */
@property (nonatomic, weak) XYSubsChannelView *subsChannelView;
/**
 *  删除工具栏，默认隐藏
 */
@property (nonatomic, weak) XYSortDelView *sortDelView;
@end

@implementation XYNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //设置导航栏上的控件
    [self setupNavView];
    
    //添加子控件
    [self setupChildView];
    
    //监听选中顶部的频道按钮
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectedChannel:) name:XYSelectedChannelIndex object:nil];
    //监听切换当前频道
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeCurrentChannel:) name:XYChangeCurrentChannel object:nil];
}


#pragma mark - 设置导航栏上的控件
- (void)setupNavView{
    //左边的UIBarButtonItem
    UIButton *leftBtn = [UIButton buttonWithNormalImage:[UIImage imageNamed:@"search_icon"] highlightedImage:[UIImage imageNamed:@"search_icon_highlighted"] target:self selcetor:@selector(leftBtnClick) controlEvent:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    
    //右边的UIBarButtonItem
    XYRightButton *rightBtn = [XYRightButton buttonWithNormalImage:[UIImage imageNamed:@"nav_coins_1"] hightlightImage:nil target:self selcetor:@selector(rightBtnClick) controlEvent:UIControlEventTouchUpInside title:@"+5/40"];
    self.rightBtn = rightBtn;
    rightBtn.width += 8;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    UIImageView *titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navbar_netease"]];
    self.navigationItem.titleView = titleView;
    
}
#pragma mark - 添加子控件
- (void)setupChildView{
    //添加订阅的频道视图
    XYSubsView *subsView = [[XYSubsView alloc] init];
    self.subsView = subsView;
    subsView.subsChannels = [XYSubsTool subssFromSandBox];
    subsView.x = 0;
    subsView.y = 0;
    subsView.width = XYScreenWidth;
//    subsView.subsDelegate = self;
    [self.view addSubview:subsView];
    
    //添加按钮模糊视图
    XYAddSubsView *addSubsView = [[XYAddSubsView alloc] initWithFrame:CGRectMake(XYScreenWidth - 50, 0, 50, subsView.height)];
    [self.view addSubview:addSubsView];
    //添加按钮
    UIButton *addBtn = [UIButton buttonWithNormalImage:[UIImage imageNamed:@"home_header_add"] highlightedImage:nil target:self selcetor:@selector(addBtnClick) controlEvent:UIControlEventTouchUpInside];
    [self.view addSubview:addBtn];
    self.addBtn = addBtn;
    addBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    addBtn.frame = CGRectMake(XYScreenWidth - addSubsView.height, 0, addSubsView.height, addSubsView.height);
    
    //添加频道视图
    XYSubsChannelView *subsChannelView = [[XYSubsChannelView alloc] initWithFrame:CGRectMake(0, -780, XYScreenWidth, XYScreenHeight)];
    [self.view addSubview:subsChannelView];
    self.subsChannelView = subsChannelView;
    
    __weak typeof(self) weakSelf = self;
    subsChannelView.newSubsChannels = ^(NSArray *subsChannels){
        
        //刷新滚动的频道按钮
        weakSelf.subsView.subsChannels = subsChannels;
    };
    
    //添加删除工具栏，默认隐藏
    XYSortDelView *sortDelView = [[XYSortDelView alloc] init];
    self.sortDelView = sortDelView;
    sortDelView.alpha = 0;
    
    sortDelView.frame = CGRectMake(0, 0, XYScreenWidth - 50, subsView.height);
    [self.view addSubview:sortDelView];
}


#pragma mark - 导航栏按钮按钮事件
- (void)leftBtnClick{
    XYSearchViewController *searchVC = [[XYSearchViewController alloc] init];
    [self.navigationController pushViewController:searchVC animated:YES];
}

- (void)rightBtnClick{
    
}

#pragma mark - 选中频道按钮
- (void)selectedChannel:(NSNotification *)noti{
    NSInteger index = [noti.userInfo[XYSelectedChannelIndex] integerValue];
//    XYLog(@"%ld", index);
//    UIButton *btn = self.subsChannelView.
    
}
#pragma mark - 监听切换当前频道
- (void)changeCurrentChannel:(NSNotification *)noti{
    //隐藏订阅频道视图
    [self hideChannelsView];
    int currentIndex = [noti.userInfo[XYChangeCurrentChannel] intValue];
    self.subsView.selectedIndex = currentIndex;
    XYLog(@"^^^^^%d", currentIndex);
    [self.subsView scrollChannelsWithIndex:currentIndex];
}
#pragma mark - 点击展示频道按钮
- (void)addBtnClick{
    
    if (CGAffineTransformIsIdentity(self.addBtn.transform)) {
        //展示
        [UIView animateWithDuration:0.4 animations:^{
            self.addBtn.transform = CGAffineTransformMakeRotation(M_PI_4);
            //隐藏tabBar
            self.tabBarController.tabBar.transform = CGAffineTransformMakeTranslation(0, 50);
            //展示频道视图
            self.subsChannelView.transform = CGAffineTransformMakeTranslation(0, 810);
            self.sortDelView.alpha = 1;
        }];
        
    }else{
        //隐藏
        [self hideChannelsView];
    }
}
//隐藏订阅频道
- (void)hideChannelsView{
    [UIView animateWithDuration:0.4 animations:^{
        self.addBtn.transform = CGAffineTransformIdentity;
        //还原tabBar
        self.tabBarController.tabBar.transform = CGAffineTransformIdentity;
        //隐藏频道视图
        self.subsChannelView.transform = CGAffineTransformIdentity;
        self.sortDelView.alpha = 0;
        //发出通知，隐藏订阅频道视图
        [[NSNotificationCenter defaultCenter] postNotificationName:XYHideChannelView object:self];
    }];

}
//移除通知
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
