//
//  XY.m
//  XYNetEasyNews
//
//  Created by 李小亚 on 16/5/22.
//  Copyright © 2016年 李小亚. All rights reserved.
//

#import "XYNewsTableView.h"
#import "XYNewsItem.h"
#import "XYAdItem.h"
#import "XYNewsHeaderView.h"
#import "XYNewsCell.h"
//#import "XYNewsViewController.h"
#import "XYMainNavController.h"
#import "XYPhotoAlbumController.h"



@interface XYNewsTableView ()<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, XYNewsHeaderViewDelegate>

@end

@implementation XYNewsTableView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.delegate = self;
        self.dataSource = self;
        
        self.rowHeight = XYNewsCellHeight;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _newsArray.count - 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    XYNewsCell *cell = [XYNewsCell newsCellWithTableCell:tableView];

    XYNewsItem *newsItem = _newsArray[indexPath.row + 1];
    
    if (indexPath.row == 0) {
        cell.topCell = YES;
    }else{
        cell.topCell = NO;
    }
    
    cell.newsItem = newsItem;
    
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return XYNewsHeaderHeight;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    XYNewsHeaderView *headerView = [XYNewsHeaderView newsHeaderWithTableView:tableView];
    
    XYNewsItem *newsItem = _newsArray[0];
    headerView.newsItem = newsItem;
    headerView.delegate = self;
    
    
    return headerView;
}

#pragma mark - XYNewsHeaderViewDelegate
- (void)newsHeaderViewDidTapImage:(XYNewsHeaderView *)headImageView adItem:(XYAdItem *)adItem{
//    XYLog(@"%@", adItem.title);
    //[UIApplication sharedApplication].keyWindow.rootViewController.childViewControllers[0].childViewControllers[0]
   
    XYMainNavController *mainNav = XYKeyWindow.rootViewController.childViewControllers[0];
    
    XYPhotoAlbumController *photoAlbumVC = [[XYPhotoAlbumController alloc] init];
    photoAlbumVC.adItem = adItem;
    [mainNav pushViewController:photoAlbumVC animated:YES];

}
#pragma mark - UIScrollViewDelegate
//header与cell一起滚动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self)
    {
        CGFloat sectionHeaderHeight = XYNewsHeaderHeight;
        if (scrollView.contentOffset.y <= sectionHeaderHeight && scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y >= sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
}
@end
