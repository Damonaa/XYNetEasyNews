//
//  XYAdItem.h
//  XYNetEasyNews
//
//  Created by 李小亚 on 16/5/22.
//  Copyright © 2016年 李小亚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYAdItem : NSObject
/**
 *  图片的URL
 */
@property (nonatomic, copy) NSString *imgsrc;
/**
 *  图片子标题
 */
@property (nonatomic, copy) NSString *subtitle;
/**
 *  图片标签
 */
@property (nonatomic, copy) NSString *tag;
/**
 *  图片标题
 */
@property (nonatomic, copy) NSString *title;
/**
 *  跳转的URL url = "00AO0001|119254";
 http://c.m.163.com/photo/api/set/0001/119318.json
 
 相关的图集
 http://c.m.163.com/photo/api/related/0001/119318.json
 
 //评论
 http://comment.api.163.com/api/json/thread/total/news_guonei8_bbs/BNRLIMN40001124J
 
 //评论个数
 http://comment.api.163.com/api/json/thread/total/photoview_bbs/PHOT3KGM000100AP
 */
@property (nonatomic, copy) NSString *url;
@end
