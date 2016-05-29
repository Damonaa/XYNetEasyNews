//
//  XYNewsHeaderView.h
//  XYNetEasyNews
//
//  Created by 李小亚 on 16/5/22.
//  Copyright © 2016年 李小亚. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XYNewsItem, XYNewsHeaderView, XYAdItem;


@protocol XYNewsHeaderViewDelegate  <NSObject>

- (void)newsHeaderViewDidTapImage:(XYNewsHeaderView *)headImageView adItem:(XYAdItem *)adItem;

@end

@interface XYNewsHeaderView : UITableViewHeaderFooterView

/**
 *  获取到的第一个XYNewsItem，其中包含（XYAdItem）ads
 */
@property (nonatomic, strong) XYNewsItem *newsItem;


@property (nonatomic, weak) id<XYNewsHeaderViewDelegate> delegate;

/**
 *  类方法 创建自定义的header
 */

+ (instancetype)newsHeaderWithTableView:(UITableView *)tableView;
@end
