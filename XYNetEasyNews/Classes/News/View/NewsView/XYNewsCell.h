//
//  XYNewsCell.h
//  XYNetEasyNews
//
//  Created by 李小亚 on 16/5/23.
//  Copyright © 2016年 李小亚. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XYNewsItem;

@interface XYNewsCell : UITableViewCell

@property (nonatomic, strong) XYNewsItem *newsItem;
/**
 *  是否是置顶的cell
 */
@property (nonatomic, assign, getter=isTopCell) BOOL topCell;


+ (instancetype)newsCellWithTableCell:(UITableView *)tableView;


@end
