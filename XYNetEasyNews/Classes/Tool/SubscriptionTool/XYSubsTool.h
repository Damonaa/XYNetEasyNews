//
//  XYSubsTool.h
//  XYNetEasyNews
//
//  Created by 李小亚 on 16/5/16.
//  Copyright © 2016年 李小亚. All rights reserved.
//用于管理订阅频道

#import <Foundation/Foundation.h>

@interface XYSubsTool : NSObject

/**
 *  从沙盒中取出已订阅的频道
 */
+ (NSMutableArray *)subssFromSandBox;

/**
 *  保存已订阅的频道到沙盒
 *
 *  @param newSubss 新的订阅频道数组
 */
+ (void)saveSubs:(NSMutableArray *)newSubss;

/**
 *  从沙盒中取出未订阅的频道
 */
+ (NSMutableArray *)unsubssFromSandBox;

/**
 *  保存未订阅的频道到沙盒
 *
 *  @param newSubss 新的未订阅频道数组
 */
+ (void)saveUnsubs:(NSMutableArray *)newUnsubss;
@end
