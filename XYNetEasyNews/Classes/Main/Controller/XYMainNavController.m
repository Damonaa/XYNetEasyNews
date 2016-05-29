//
//  XYMainViewController.m
//  XYNetEasyNews
//
//  Created by 李小亚 on 16/5/15.
//  Copyright © 2016年 李小亚. All rights reserved.
//

#import "XYMainNavController.h"
#import "XYPhotoAlbumController.h"

@interface XYMainNavController ()<UINavigationControllerDelegate>

@property (nonatomic, strong) id popDelegate;

@property (nonatomic, weak) UIView *navBarView;

@end

@implementation XYMainNavController


+ (void)initialize{
    UINavigationBar *bar = [UINavigationBar appearanceWhenContainedIn:self, nil];
    //设置navigation的背景图片
//    [bar setBackgroundImage:[UIImage imageNamed:@"top_navigation_background"] forBarMetrics:UIBarMetricsDefault];
    
    //设置nav的字体
    NSMutableDictionary *navAttr = [NSMutableDictionary dictionary];
    navAttr[NSForegroundColorAttributeName] = [UIColor whiteColor];
    navAttr[NSFontAttributeName] = [UIFont systemFontOfSize:20];
    [bar setTitleTextAttributes:navAttr];
    
    //设置UIBarButtonItem属性
    UIBarButtonItem *barBtnItem = [UIBarButtonItem appearanceWhenContainedIn:self, nil];
    
    //设置UIBarButtonItem字体
    NSMutableDictionary *attrBar = [NSMutableDictionary dictionary];
    attrBar[NSForegroundColorAttributeName] = [UIColor whiteColor];
    attrBar[NSFontAttributeName] = [UIFont systemFontOfSize:15];
    [barBtnItem setTitleTextAttributes:attrBar forState:UIControlStateNormal];

}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.delegate = self;
    self.popDelegate = self.interactivePopGestureRecognizer.delegate;
    self.interactivePopGestureRecognizer.delegate = nil;
}


//隐藏tabBar
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.viewControllers.count != 0) {
        viewController.hidesBottomBarWhenPushed = YES;
        //添加返回按钮
        UIButton *backBtn = [UIButton buttonWithNormalImage:[UIImage imageNamed:@"top_navigation_back"] highlightedImage:[UIImage imageNamed:@"icon_back_highlighted"] target:self selcetor:@selector(backBtnClick) controlEvent:UIControlEventTouchUpInside];
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
        
    }
    
    [super pushViewController:viewController animated:animated];
}


//设置手势代理
//已经过渡到下一个控制器
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (viewController == self.viewControllers[0]) {//是第一个控制器。则还原手势代理
        self.interactivePopGestureRecognizer.delegate = self.popDelegate;
    }else{
        self.interactivePopGestureRecognizer.delegate = nil;
    }
}
//将要过渡要下一个控制器
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if ([viewController isKindOfClass:[XYPhotoAlbumController class]]) {
        for (UIView *view in self.view.subviews) {
            if ([view isKindOfClass:NSClassFromString(@"UINavigationBar")]) {
//                XYLog(@"%@", view);
                self.navBarView = view;
                [view removeFromSuperview];
            }
        }
        
    }else{
        [self.view addSubview:_navBarView];
        
        [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"top_navigation_background"] forBarMetrics:UIBarMetricsDefault];
//        self.navigationBar.alpha = 1.0;
        
    }
}

- (void)backBtnClick{
    [self popViewControllerAnimated:YES];
}
@end
