//
//  XYSubsView.h
//  XYNetEasyNews
//
//  Created by 李小亚 on 16/5/16.
//  Copyright © 2016年 李小亚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XYSubsView : UIScrollView

/**
 *  已订阅的频道
 */
@property (nonatomic, strong) NSArray *subsChannels;
/**
 *  选中的index, 默认是0
 */
@property (nonatomic, assign) NSInteger selectedIndex;

/**
 *  滚动视图到index位置
 */
- (void)scrollChannelsWithIndex:(int)index;
@end
