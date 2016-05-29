//
//  XYNewsItem.h
//  XYNetEasyNews
//
//  Created by 李小亚 on 16/5/22.
//  Copyright © 2016年 李小亚. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XYAdItem;

@interface XYNewsItem : NSObject
/**
 *  滚动视图模型
 */
@property (nonatomic, strong) NSArray *ads;
/**
 *
 */
@property (nonatomic, copy) NSString *boardid;
/**
 *
 */
@property (nonatomic, assign) NSInteger clkNum;
/**
 *  摘要
 */
@property (nonatomic, copy) NSString *digest;
/**
 *  http://c.m.163.com/nc/article/BNRLIMN40001124J/full.html
 获取文章详情
 
 、、评论
 http://comment.api.163.com/api/json/post/list/new/hot/news_guonei8_bbs/BNRLIMN40001124J/0/10/10/2/2
 
 、、
 specialID = S1451880983492;
 */
@property (nonatomic, copy) NSString *docid;
/**
 习大大
 *  置顶的URL http://c.m.163.com/nc/special/S1451880983492.html
 */
@property (nonatomic, copy) NSString *specialID;

@property (nonatomic, assign) NSInteger downTimes;
/**
 *  图片的URL
 */
@property (nonatomic, copy) NSString *img;

@property (nonatomic, copy) NSString *interest;

@property (nonatomic, copy) NSString *lmodify;

@property (nonatomic, assign) NSInteger picCount;

@property (nonatomic, copy) NSString *program;

@property (nonatomic, copy) NSString *ptime;
/**
 *  原因
 */
@property (nonatomic, copy) NSString *recReason;
/**
 *  接受来源
 */
@property (nonatomic, copy) NSString *recSource;
/**
 *  maybe __url
 */
@property (nonatomic, copy) NSString *photosetID;

@property (nonatomic, assign) NSInteger recType;

@property (nonatomic, copy) NSString *recprog;
/**
 *  跟帖次数
 */
@property (nonatomic, assign) NSInteger replyCount;

@property (nonatomic, copy) NSString *source;

@property (nonatomic, copy) NSString *template;

@property (nonatomic, copy) NSString *title;
/**
 *  不喜欢的原因
 */
@property (nonatomic, strong) NSArray *unlikeReason;

@property (nonatomic, assign) NSInteger upTimes;


@end
