//
//  XYAlbum.h
//  XYNetEasyNews
//
//  Created by 李小亚 on 16/5/24.
//  Copyright © 2016年 李小亚. All rights reserved.
//相关的图集 + url的后半段
//http://c.m.163.com/photo/api/related/0001/119318.json
 //评论
//http://comment.api.163.com/api/json/thread/total/news_guonei8_bbs/BNRLIMN40001124J
//评论个数 + postid
//http://comment.api.163.com/api/json/thread/total/photoview_bbs/PHOT3KGM000100AP

#import <Foundation/Foundation.h>

@interface XYAlbum : NSObject

/**
 *  图集的id
 */
@property (nonatomic, copy) NSString *postid;
/**
 *  存放（XYAlbumPhoto）
 */
@property (nonatomic, strong) NSArray *photos;
/**
 *  图集标题
 */
@property (nonatomic, copy) NSString *setname;
/**
 *  图片个数
 */
@property (nonatomic, assign) NSInteger imgsum;
/**
 *  相关图集的id
 */
@property (nonatomic, copy) NSString *setid;
/**
 *  相关图集的图片URL
 */
@property (nonatomic, copy) NSString *clientcover1;


@end
