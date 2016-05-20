//
//  XYSubsChannelView.h
//  XYNetEasyNews
//
//  Created by 李小亚 on 16/5/17.
//  Copyright © 2016年 李小亚. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^NewSubsChannelsBlock)(NSArray *subsChannels);

@interface XYSubsChannelView : UIScrollView

/**
 *  新的已订阅频道
 */
@property (nonatomic, copy) NewSubsChannelsBlock newSubsChannels;

/**
 *  是否是排序删除状态， 默认为NO
 */
@property (nonatomic, assign, getter=isSortDel) BOOL sortDel;

/**
 *  隐藏频道视图
 */
- (void)hideChannelView;
@end
