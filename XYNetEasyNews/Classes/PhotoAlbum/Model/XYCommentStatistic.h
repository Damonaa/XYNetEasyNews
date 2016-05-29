//
//  XYCommentStatistic.h
//  XYNetEasyNews
//
//  Created by 李小亚 on 16/5/25.
//  Copyright © 2016年 李小亚. All rights reserved.
// http://comment.api.163.com/api/json/thread/total/photoview_bbs/PHOT3KGM000100AP

#import <Foundation/Foundation.h>

@interface XYCommentStatistic : NSObject
/**
 *  {
	"againstcount": 21,
	"audioLock": "1",
	"code": "1",
	"prcount": 1075,
	"ptcount": 1058,
	"threadAgainst": 0,
	"threadVote": 0,
	"votecount": 9356
 }
 */
/**
*  跟帖个数
*/
@property (nonatomic, assign) NSInteger votecount;

@property (nonatomic, assign) NSInteger prcount;



@end
