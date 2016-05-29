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
#import "XYNews.h"
#import "XYNewsContainerView.h"
#import "XYNews.h"


@interface XYNewsViewController ()<UIScrollViewDelegate>
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
/**
 *  存放新闻详情的容器
 */
@property (nonatomic, weak) XYNewsContainerView *newsContainer;
@end

@implementation XYNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    //展示新闻数据的容器
    XYNewsContainerView *newsContainer = [[XYNewsContainerView alloc] init];
    self.newsContainer = newsContainer;
    [self.view addSubview:newsContainer];
    newsContainer.delegate = self;
    newsContainer.frame = CGRectMake(0, 31, self.view.width, self.view.height);
    
    __weak typeof(self) weakSelf = self;
    //获取到新的数据
    newsContainer.newsContainerGet = ^(NSInteger newsCount){
        [weakSelf showNewNewsCount:newsCount];
    };
    
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


/**
*  显示提示框
*/
- (void)showNewNewsCount:(NSInteger)count{
    
    if (count == 0) {
        return;
    }
    
    UILabel *remind = [[UILabel alloc] init];
    remind.text = [NSString stringWithFormat:@"为你更新了%ld条新闻", count];
    
    CGFloat remindW = self.view.width;
    CGFloat remindH = 25;
    CGFloat remindX = 0;
    CGFloat remindY = CGRectGetMaxY(self.navigationController.navigationBar.frame) - remindH;
    remind.frame = CGRectMake(remindX, remindY, remindW, remindH);
    
    remind.backgroundColor = [UIColor colorWithRed:0.161 green:0.691 blue:1.000 alpha:1.000];
    remind.textColor = [UIColor whiteColor];
    remind.textAlignment = NSTextAlignmentCenter;
    remind.font = [UIFont systemFontOfSize:12];
    
    //    将label插入到导航条的底部
    [self.navigationController.view insertSubview:remind belowSubview:self.navigationController.navigationBar];
    
    //    下拉刷新，label下移动，刷新结束后，延时 复位 移除
    [UIView animateWithDuration:0.25 animations:^{
        remind.transform = CGAffineTransformMakeTranslation(0, remindH);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.25 delay:1.3 options:UIViewAnimationOptionCurveLinear animations:^{
            remind.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [remind removeFromSuperview];
        }];
    }];
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    int page = (scrollView.contentOffset.x + scrollView.width / 2) / scrollView.width;

//    XYLog(@"%d", page);
    //当前的按钮
    NSInteger currentPage;
    //将要过渡的按钮
    NSInteger nextPage;
    //当前按钮的字体
    CGFloat currentFontSize;
    //将要过渡到的字体
    CGFloat nextFontSize;
    //滑动的进度
    float progress;
    //红色的百分比
    float currentRedPer;//0.691 - -- 0
    float nextRedPer;
    //判断向左还是向右滑动
    static float newX = 0;
    static float oldX = 0;
    
    //当前的按钮
    UIButton *currentBtn;
    UIButton *nextBtn;
    
    UIButton *deliverBtn;
    
    newX = scrollView.contentOffset.x;
    if (newX != oldX) {
        
        if (newX > oldX) {//向右
            currentPage = scrollView.contentOffset.x / scrollView.width;
            nextPage = currentPage + 1;
            //滑动的进度
            progress = scrollView.contentOffset.x / scrollView.width * 1.0 - currentPage;
            currentFontSize = 18 - 2 * progress;
            nextFontSize = 16 + 2 * progress;
            
            currentRedPer = (1 - progress) * 0.691 ;
            nextRedPer = progress * 0.691;
            deliverBtn = currentBtn;
            
        }else if (newX < oldX){//向左滚动
            currentPage = scrollView.contentOffset.x / scrollView.width + 1;
            nextPage = currentPage - 1;
            //滑动的进度
            progress = scrollView.contentOffset.x / scrollView.width * 1.0 - currentPage;
            currentFontSize = 18 + 2 * progress;
            nextFontSize = 16 - 2 * progress;
            
            currentRedPer = (1 + progress) * 0.691;
            nextRedPer = -1 * progress * 0.691;
            
            deliverBtn = nextBtn;
        }
        oldX = newX;
    }
    
    //当前的按钮
    if (currentPage >= 0 && currentPage < self.subsView.subviews.count) {
        currentBtn = _subsView.subviews[currentPage];
    }
    //设置字体大小
    currentBtn.titleLabel.font = [UIFont systemFontOfSize:currentFontSize];
    //设置颜色
    [currentBtn setTitleColor:[UIColor colorWithRed:currentRedPer green:0.000 blue:0.000 alpha:1.000] forState:UIControlStateNormal];
    
    
    //将要过渡到的按钮
    
    if (nextPage >= 0 && nextPage < self.subsView.subviews.count) {
        nextBtn = _subsView.subviews[nextPage];
    }
    nextBtn.titleLabel.font = [UIFont systemFontOfSize:nextFontSize];
    //设置颜色
    [nextBtn setTitleColor:[UIColor colorWithRed:nextRedPer green:0.000 blue:0.000 alpha:1.000] forState:UIControlStateNormal];
    
    //切换选的按钮
    if (deliverBtn) {
        [[NSNotificationCenter defaultCenter] postNotificationName:XYScrollContainer object:self userInfo:@{XYScrollContainer:deliverBtn}];
    }

    
//    XYLog(@"color - current %f -- next %f", currentRedPer, nextRedPer);
//    XYLog(@"progress %f- current page %ld -next page %ld-currentFontSize %f-nextFontSize %f", progress, currentPage, nextPage, currentFontSize, nextFontSize);
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
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
    self.newsContainer.contentOffset = CGPointMake(XYScreenWidth * index, 0);
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
