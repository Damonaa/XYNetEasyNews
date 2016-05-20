//
//  XYTabBarViewController.m
//  XYNetEasyNews
//
//  Created by 李小亚 on 16/5/15.
//  Copyright © 2016年 李小亚. All rights reserved.
//

#import "XYTabBarViewController.h"
#import "UIImage+XY.h"
#import "XYMainNavController.h"
#import "XYNewsViewController.h"
#import "XYReadViewController.h"
#import "XYVideosViewController.h"
#import "XYTopicsViewController.h"
#import "XYProfileViewController.h"

@interface XYTabBarViewController ()

@end

@implementation XYTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupChildViewController];
}

//添加子控制器
- (void)setupChildViewController{
    XYNewsViewController *newsVC = [[XYNewsViewController alloc] init];
    [self setupOneViewControllerWithVC:newsVC image:[UIImage imageNamed:@"tabbar_icon_news_normal"] selectedImage:[UIImage imageNamed:@"tabbar_icon_news_highlight"] title:@"新闻"];
    newsVC.view.backgroundColor = [UIColor whiteColor];
    
    XYReadViewController *readVC = [[XYReadViewController alloc] init];
    [self setupOneViewControllerWithVC:readVC image:[UIImage imageNamed:@"tabbar_icon_reader_normal"] selectedImage:[UIImage imageNamed:@"tabbar_icon_reader_highlight"] title:@"阅读"];
    readVC.view.backgroundColor = [UIColor whiteColor];
    
    XYVideosViewController *videosVC = [[XYVideosViewController alloc] init];
    [self setupOneViewControllerWithVC:videosVC image:[UIImage imageNamed:@"tabbar_icon_media_normal"] selectedImage:[UIImage imageNamed:@"tabbar_icon_media_highlight"] title:@"视频"];
    videosVC.view.backgroundColor = [UIColor redColor];
    
    XYTopicsViewController *topicsVC = [[XYTopicsViewController alloc] init];
    [self setupOneViewControllerWithVC:topicsVC image:[UIImage imageNamed:@"tabbar_icon_bar_normal"] selectedImage:[UIImage imageNamed:@"tabbar_icon_bar_highlight"] title:@"话题"];
    topicsVC.view.backgroundColor = [UIColor whiteColor];
    
    XYProfileViewController *profileVC = [[XYProfileViewController alloc] init];
    [self setupOneViewControllerWithVC:profileVC image:[UIImage imageNamed:@"tabbar_icon_me_normal"] selectedImage:[UIImage imageNamed:@"tabbar_icon_me_highlight"] title:@"我"];
    profileVC.view.backgroundColor = [UIColor orangeColor];
    
}


//创建一个子控制器
- (void)setupOneViewControllerWithVC:(UIViewController *)vc image:(UIImage *)image selectedImage:(UIImage *)selectedImage title:(NSString *)title{
    
    vc.tabBarItem.image = image;
    vc.tabBarItem.selectedImage = [UIImage imageWithOriginal:selectedImage];
    vc.title = title;
    
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    attr[NSForegroundColorAttributeName] = XYTextColor;
    
    [vc.tabBarItem setTitleTextAttributes:attr forState:UIControlStateSelected];
    
    XYMainNavController *mainNav = [[XYMainNavController alloc] initWithRootViewController:vc];
    
    
    [self addChildViewController:mainNav];
}
@end
