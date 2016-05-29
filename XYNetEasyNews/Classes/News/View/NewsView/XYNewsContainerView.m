//
//  XYNewsContainerView.m
//  XYNetEasyNews
//
//  Created by 李小亚 on 16/5/22.
//  Copyright © 2016年 李小亚. All rights reserved.
//

#import "XYNewsContainerView.h"
#import "XYSubsTool.h"
#import "XYNewsTableView.h"
#import "XYNews.h"
#import "XYHttpTool.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "XYNewsItem.h"

@interface XYNewsContainerView ()

@property (nonatomic, weak) XYNewsTableView *newsTableView;
/**
 *  存放获取到的全部的新闻
 */
@property (nonatomic, strong) NSMutableArray *allNews;
/**
 *  当前的页码，默认为0
 */
@property (nonatomic, strong) NSNumber *currentPageIndex;


@end

@implementation XYNewsContainerView

- (NSMutableArray *)allNews{
    if (!_allNews) {
        _allNews = [NSMutableArray array];
    }
    return _allNews;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupChildView];
        NSArray *subss = [XYSubsTool subssFromSandBox];
        self.contentSize = CGSizeMake(subss.count * XYScreenWidth, 0);
        self.pagingEnabled = YES;
        self.currentPageIndex = [NSNumber numberWithInt:0];
        
        //添加顶部刷新
        [self.newsTableView addHeaderWithTarget:self action:@selector(headerRereshing)];
        //2. 添加尾部控件的方法
        [self.newsTableView addFooterWithTarget:self action:@selector(footerRereshing)];
        [self headerRereshing];
    }
    return self;
}
//添加子控件
- (void)setupChildView{
    XYNewsTableView *newsTableView = [[XYNewsTableView alloc] init];
    [self addSubview:newsTableView];
    self.newsTableView = newsTableView;
    
}

//布局子控件位置
- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.newsTableView.frame = CGRectMake(0, 0, self.width, self.height - XYNewsHeaderHeight + 35);
}


//添加顶部刷新，获取全新的数据
- (void)headerRereshing{
    //获取数据
    /**
     *  @"http://c.m.163.com/nc/article/headline/T1348647853363/0-20.html?from=toutiao&fn=1&passport=s5bIpjkdt3%2FBRUJRhRJsUBL7HDUxyPKDuqXg8sOgz5U%3D&devId=hm2kynpHxrQ8NZFOIU%2BJSS0YGBYFZ30%2F6to6oNDp%2F4pZ1QU6Eb3cEv5%2B8xCJKC85&size=20&version=8.1&spever=false&net=wifi&lat=&lon=&ts=1463391644&sign=nshOxheLMEvZPm8Z1bVEZNxcy8oaeS9kNqEe8I8n04d48ErR02zJ6%2FKXOnxX046I&encryption=1&canal=appstore"
     */
    NSString *urlStr = @"http://c.m.163.com/nc/article/headline/T1348647853363/0-20.html?from=toutiao&fn=1&passport=s5bIpjkdt3%2FBRUJRhRJsUBL7HDUxyPKDuqXg8sOgz5U%3D&devId=hm2kynpHxrQ8NZFOIU%2BJSS0YGBYFZ30%2F6to6oNDp%2F4pZ1QU6Eb3cEv5%2B8xCJKC85&size=20";
    [XYHttpTool GET:urlStr parameters:nil success:^(id responseObject) {
        XYNews *news = [XYNews objectWithKeyValues:responseObject];
//        XYLog(@"%@",responseObject);
        //判断获取的数据与数组的前10条是否相同
        
        BOOL getNews = YES;
        if (_allNews) {
            for (int i = 2; i < news.T1348647853363.count; i ++) {
                XYNewsItem *newsItem = news.T1348647853363[i];
                XYNewsItem *oldItem = _allNews[i];
                if ([newsItem.docid isEqualToString:oldItem.docid]) {//不相同
                    getNews = NO;
                    break;
                }
            }
        }
        
        
        //是  刷新
        if (getNews) {
            //通知控制器，获取新的数据
            if (_newsContainerGet) {
                _newsContainerGet(news.T1348647853363.count);
//                _newsContainerGet = nil;
            }
           //移除内存中原有的数据
            [self.allNews removeAllObjects];
            //添加数据到内存数组中
            self.allNews = (NSMutableArray *)news.T1348647853363;
            //数据传给tableView
            self.newsTableView.newsArray = _allNews;
            //刷新表格
            [self.newsTableView reloadData];
        }
        //结束刷新
        [self.newsTableView headerEndRefreshing];
    } failure:^(NSError *error) {
        XYLog(@"%@", error);
        [self.newsTableView headerEndRefreshing];
    }];
}

/**
 *  http://c.m.163.com/nc/article/headline/T1348647853363/0-20.html?from=toutiao&fn=1&prog=LTitleA&passport=s5bIpjkdt3%2FBRUJRhRJsUBL7HDUxyPKDuqXg8sOgz5U%3D&devId=hm2kynpHxrQ8NZFOIU%2BJSS0YGBYFZ30%2F6to6oNDp%2F4pZ1QU6Eb3cEv5%2B8xCJKC85&size=20&version=9.0&spever=false&net=wifi&lat=0qy8jor4LyVHABGPBkjn0Q%3D%3D&lon=WKwwyf6kzxKyKCH8eUfrHw%3D%3D&ts=1464000374&sign=PIzRTfwwdmKaJGWWAQDgYiol5ELGtVvMEEa8PQypBEZ48ErR02zJ6%2FKXOnxX046I&encryption=1&canal=appstore

 */
//添加尾部控件的方法
- (void)footerRereshing{
    
    int currentPage = [_currentPageIndex intValue] + 1;
    
    _currentPageIndex = [NSNumber numberWithInt:currentPage];
    
    NSString *urlStr = [NSString stringWithFormat:@"http://c.m.163.com/nc/article/headline/T1348647853363/%d0-20.html?from=toutiao&fn=1&passport=s5bIpjkdt3%%2FBRUJRhRJsUBL7HDUxyPKDuqXg8sOgz5U%%3D&devId=hm2kynpHxrQ8NZFOIU%%2BJSS0YGBYFZ30%%2F6to6oNDp%%2F4pZ1QU6Eb3cEv5%%2B8xCJKC85&size=20", [_currentPageIndex intValue]];
    ;
    [XYHttpTool GET:urlStr parameters:nil success:^(id responseObject) {
        XYNews *news = [XYNews objectWithKeyValues:responseObject];
        XYLog(@"%@",responseObject);
//        self.news = news;
        
        //计算需要刷新的cell
        NSMutableArray *indexPaths = [NSMutableArray array];
        for (int i = 0; i < news.T1348647853363.count; i ++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_allNews.count + i - 1 inSection:0];
            [indexPaths addObject:indexPath];
        }
        //新的数据插入数组
        [self.allNews addObjectsFromArray:news.T1348647853363];
        
        self.newsTableView.newsArray = _allNews;
        
//        [self.newsTableView reloadData];
        //刷新表格
        [self.newsTableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
//        [self.newsTableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
//
        [self.newsTableView footerEndRefreshing];
    } failure:^(NSError *error) {
        XYLog(@"%@", error);
        [self.newsTableView footerEndRefreshing];
    }];
}
@end
