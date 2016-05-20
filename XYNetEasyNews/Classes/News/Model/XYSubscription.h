//
//  XYSubscription.h
//  XYNetEasyNews
//
//  Created by 李小亚 on 16/5/16.
//  Copyright © 2016年 李小亚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYSubscription : NSObject<NSCoding>
/**
 *  显示的名称
 */
@property (nonatomic, copy) NSString *title;
/**
 *  服务器请求用的名称
 */
@property (nonatomic, copy) NSString *codeName;
/**
 *  是否是热门订阅
 */
@property (nonatomic, assign, getter=isHotSubs) BOOL hotSubs;
/**
 *  是否是新的订阅
 */
@property (nonatomic, assign, getter=isNewSubs) BOOL newSubs;


/**
 *  实例方法初始化创建XYSubscription
 *
 *  @param title    显示的名称
 *  @param codeName 服务器请求用的名称
 *  @param hotSubs  是否是热门订阅
 *  @param newSubs  是否是新的订阅
 *
 *  @return XYSubscription
 */
- (instancetype)initWithTitle:(NSString *)title codeName:(NSString *)codeName hotSubs:(BOOL)hotSubs newSubs:(BOOL)newSubs;
/**
 *  类方法初始化创建XYSubscription
 *
 *  @param title    显示的名称
 *  @param codeName 服务器请求用的名称
 *  @param hotSubs  是否是热门订阅
 *  @param newSubs  是否是新的订阅
 *
 *  @return XYSubscription
 */
+ (instancetype)subscriptionWithTitle:(NSString *)title codeName:(NSString *)codeName hotSubs:(BOOL)hotSubs newSubs:(BOOL)newSubs;
@end
