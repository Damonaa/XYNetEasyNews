//
//  XYSubsChannels.h
//  XYNetEasyNews
//
//  Created by 李小亚 on 16/5/17.
//  Copyright © 2016年 李小亚. All rights reserved.
//已经订阅的频道

#import <UIKit/UIKit.h>

typedef void(^ChannelsHeightBlock)(CGFloat height);

@interface XYChannelsView : UIView
/**
 *  要展示的频道（XYScription）
 */
@property (nonatomic, strong) NSMutableArray *channels;

@property (nonatomic, copy) ChannelsHeightBlock channelsHeight;

/**
 *  存放全部的频道按钮
 */
@property (nonatomic, strong) NSMutableArray *channelBtns;

@end
