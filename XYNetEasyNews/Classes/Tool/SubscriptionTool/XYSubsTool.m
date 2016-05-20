//
//  XYSubsTool.m
//  XYNetEasyNews
//
//  Created by 李小亚 on 16/5/16.
//  Copyright © 2016年 李小亚. All rights reserved.
//

/** 全部频道
 *  "iosnews", "Huabao", "yule", "specialRedian", "tiyu", "specialLocal", "specialSub", "caijing", "keji", "qiche", "nvren", "specialPicture", "specialComment", "fangchan", "specialLive", "qingsongyike", "specialJoke", "junshi", "lishi", "jiaju", "zhenhua", "youxi", "jiankang", "manhua", "dada", "caipiao", "specialGirl", "NBA", "shehui", "dianying", "zhongchao", "specialAnimal", "specialBoy", "specialBBS", "zhengwu", "qinggan", "jiaoyu", "specialBlog", "qinzi", "jiuxiang", "attitude open", "gongkaike", "paobu", "shuma", "shouji", "yidonghulianwang", "zuqiu", "baoxue", "dushu", "Art", "CBA", "lvyou
 */


#define XYSubscriptions   @"subscriptions"
#define XYUnsubscriptions @"unsubscriptions"

#import "XYSubsTool.h"
#import "XYSubscription.h"

@implementation XYSubsTool
//已经订阅的频道
static NSMutableArray *subss;
//未订阅的频道
static NSMutableArray *unsubss;

+(void)initialize{
    
    
}

/**
 *  从偏好设置中取出已订阅的频道
 */
+ (NSMutableArray *)subssFromSandBox{
    subss = [NSMutableArray array];
    //先从偏好设置中取
    NSMutableArray *tempA = [[NSUserDefaults standardUserDefaults] objectForKey:XYSubscriptions];
    if (tempA) {
        for (NSData *subsData in tempA) {
            XYSubscription *subs= [NSKeyedUnarchiver unarchiveObjectWithData:subsData];
            
            [subss addObject:subs];
        }
    }
    //如果没有取到
    if (subss.count == 0) {//如果从沙盒中取出来的是空，则手动添加
        XYSubscription *subs1 = [XYSubscription subscriptionWithTitle:@"头条" codeName:@"iosnews" hotSubs:NO newSubs:NO];
        XYSubscription *subs2 = [XYSubscription subscriptionWithTitle:@"娱乐" codeName:@"yule" hotSubs:NO newSubs:NO];
        XYSubscription *subs3 = [XYSubscription subscriptionWithTitle:@"热点" codeName:@"specialRedian" hotSubs:NO newSubs:NO];
        XYSubscription *subs4 = [XYSubscription subscriptionWithTitle:@"体育" codeName:@"tiyu" hotSubs:NO newSubs:NO];
        XYSubscription *subs5 = [XYSubscription subscriptionWithTitle:@"本地" codeName:@"specialLocal" hotSubs:YES newSubs:NO];
        XYSubscription *subs6 = [XYSubscription subscriptionWithTitle:@"网易号" codeName:@"specialSub" hotSubs:NO newSubs:YES];
        XYSubscription *subs7 = [XYSubscription subscriptionWithTitle:@"财经" codeName:@"caijing" hotSubs:NO newSubs:NO];
        XYSubscription *subs8 = [XYSubscription subscriptionWithTitle:@"科技" codeName:@"keji" hotSubs:NO newSubs:NO];
        XYSubscription *subs9 = [XYSubscription subscriptionWithTitle:@"汽车" codeName:@"qiche" hotSubs:NO newSubs:NO];
        XYSubscription *subs10 = [XYSubscription subscriptionWithTitle:@"时尚" codeName:@"nvren" hotSubs:NO newSubs:NO];
        XYSubscription *subs11 = [XYSubscription subscriptionWithTitle:@"图片" codeName:@"specialPicture" hotSubs:NO newSubs:NO];
        XYSubscription *subs12 = [XYSubscription subscriptionWithTitle:@"跟帖" codeName:@"specialComment" hotSubs:NO newSubs:NO];
        XYSubscription *subs13 = [XYSubscription subscriptionWithTitle:@"房产" codeName:@"fangchan" hotSubs:NO newSubs:NO];
        XYSubscription *subs14 = [XYSubscription subscriptionWithTitle:@"直播" codeName:@"specialLive" hotSubs:YES newSubs:NO];
        XYSubscription *subs15 = [XYSubscription subscriptionWithTitle:@"轻松一刻" codeName:@"qingsongyike" hotSubs:NO newSubs:NO];
        XYSubscription *subs16 = [XYSubscription subscriptionWithTitle:@"段子" codeName:@"specialJoke" hotSubs:NO newSubs:NO];
        XYSubscription *subs17 = [XYSubscription subscriptionWithTitle:@"军事" codeName:@"junshi" hotSubs:NO newSubs:NO];
        XYSubscription *subs18 = [XYSubscription subscriptionWithTitle:@"历史" codeName:@"lishi" hotSubs:NO newSubs:NO];
        XYSubscription *subs19 = [XYSubscription subscriptionWithTitle:@"家居" codeName:@"jiaju" hotSubs:NO newSubs:NO];
        XYSubscription *subs20 = [XYSubscription subscriptionWithTitle:@"独家" codeName:@"zhenhua" hotSubs:NO newSubs:NO];
        XYSubscription *subs21 = [XYSubscription subscriptionWithTitle:@"游戏" codeName:@"youxi" hotSubs:NO newSubs:NO];
        XYSubscription *subs22 = [XYSubscription subscriptionWithTitle:@"健康" codeName:@"jiankang" hotSubs:NO newSubs:NO];
        XYSubscription *subs23 = [XYSubscription subscriptionWithTitle:@"漫画" codeName:@"manhua" hotSubs:NO newSubs:NO];
        XYSubscription *subs24 = [XYSubscription subscriptionWithTitle:@"哒哒趣闻" codeName:@"dada" hotSubs:NO newSubs:NO];
        XYSubscription *subs25 = [XYSubscription subscriptionWithTitle:@"彩票" codeName:@"caipiao" hotSubs:NO newSubs:NO];
        XYSubscription *subs26 = [XYSubscription subscriptionWithTitle:@"美女" codeName:@"specialGirl" hotSubs:NO newSubs:YES];
        XYSubscription *subs27 = [XYSubscription subscriptionWithTitle:@"NBA" codeName:@"NBA" hotSubs:NO newSubs:NO];
        
        subss = [NSMutableArray arrayWithObjects:subs1,subs2,subs3,subs4,subs5,subs6,subs7,subs8,subs9,subs10,subs11,subs12,subs13,subs14,subs15,subs16,subs17,subs18,subs19,subs20,subs21,subs22,subs23,subs24,subs25,subs26,subs27, nil];
        
        
        //保存到沙盒
        [self saveSubs:subss];
    }
    return subss;
}
/**
 *  保存已订阅的频道到偏好设置
 *
 *  @param newSubss 新的订阅频道数组
 */
+ (void)saveSubs:(NSMutableArray *)newSubss{
    NSMutableArray *tempA = [NSMutableArray array];
    for (XYSubscription *subs in newSubss) {
        NSData *subsData = [NSKeyedArchiver archivedDataWithRootObject:subs];
        [tempA addObject:subsData];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:tempA forKey:XYSubscriptions];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/**
 *  从偏好设置中取出未订阅的频道
 */
+ (NSMutableArray *)unsubssFromSandBox{
    unsubss = [NSMutableArray array];
    NSMutableArray *tempA = [[NSUserDefaults standardUserDefaults] objectForKey:XYUnsubscriptions];
    if (tempA) {
        for (NSData *subsData in tempA) {
            XYSubscription *subs = [NSKeyedUnarchiver unarchiveObjectWithData:subsData];
            [unsubss addObject:subs];
        }
    }
    if (unsubss.count == 0) {//如果从沙盒中取出来的是空，则手动添加
        /** 全部频道
         "shehui", "dianying", "zhongchao", "specialAnimal", "specialBoy", "specialBBS", "zhengwu", "qinggan", "jiaoyu", "specialBlog", "qinzi", "jiuxiang", "attitude open", "gongkaike", "paobu", "shuma", "shouji", "yidonghulianwang", "zuqiu", "baoxue", "dushu", "Art", "CBA", "lvyou
         */
        
        XYSubscription *subs1 = [XYSubscription subscriptionWithTitle:@"社会" codeName:@"shehui" hotSubs:NO newSubs:NO];
        XYSubscription *subs2 = [XYSubscription subscriptionWithTitle:@"电影" codeName:@"dianying" hotSubs:NO newSubs:NO];
        XYSubscription *subs3 = [XYSubscription subscriptionWithTitle:@"中超" codeName:@"zhongchao" hotSubs:NO newSubs:NO];
        XYSubscription *subs4 = [XYSubscription subscriptionWithTitle:@"萌宠" codeName:@"specialAnimal" hotSubs:NO newSubs:NO];
        XYSubscription *subs5 = [XYSubscription subscriptionWithTitle:@"型男" codeName:@"specialBoy" hotSubs:YES newSubs:NO];
        XYSubscription *subs6 = [XYSubscription subscriptionWithTitle:@"论坛" codeName:@"specialBBS" hotSubs:NO newSubs:YES];
        XYSubscription *subs7 = [XYSubscription subscriptionWithTitle:@"政务" codeName:@"zhengwu" hotSubs:NO newSubs:NO];
        XYSubscription *subs8 = [XYSubscription subscriptionWithTitle:@"情感" codeName:@"qinggan" hotSubs:NO newSubs:NO];
        XYSubscription *subs9 = [XYSubscription subscriptionWithTitle:@"教育" codeName:@"jiaoyu" hotSubs:NO newSubs:NO];
        XYSubscription *subs10 = [XYSubscription subscriptionWithTitle:@"博客" codeName:@"specialBlog" hotSubs:NO newSubs:NO];
        XYSubscription *subs11 = [XYSubscription subscriptionWithTitle:@"亲子" codeName:@"qinzi" hotSubs:NO newSubs:NO];
        XYSubscription *subs12 = [XYSubscription subscriptionWithTitle:@"酒香" codeName:@"jiuxiang" hotSubs:NO newSubs:NO];
        XYSubscription *subs13 = [XYSubscription subscriptionWithTitle:@"态度公开课" codeName:@"attitude open" hotSubs:NO newSubs:NO];
        XYSubscription *subs14 = [XYSubscription subscriptionWithTitle:@"云课堂" codeName:@"gongkaike" hotSubs:YES newSubs:NO];
        XYSubscription *subs15 = [XYSubscription subscriptionWithTitle:@"跑步" codeName:@"paobu" hotSubs:NO newSubs:NO];
        XYSubscription *subs16 = [XYSubscription subscriptionWithTitle:@"数码" codeName:@"shuma" hotSubs:NO newSubs:NO];
        XYSubscription *subs17 = [XYSubscription subscriptionWithTitle:@"手机" codeName:@"shouji" hotSubs:NO newSubs:NO];
        XYSubscription *subs18 = [XYSubscription subscriptionWithTitle:@"移动互联网" codeName:@"yidonghulianwang" hotSubs:NO newSubs:NO];
        XYSubscription *subs19 = [XYSubscription subscriptionWithTitle:@"足球" codeName:@"zuqiu" hotSubs:NO newSubs:NO];
        XYSubscription *subs20 = [XYSubscription subscriptionWithTitle:@"暴雪游戏" codeName:@"baoxue" hotSubs:NO newSubs:NO];
        XYSubscription *subs21 = [XYSubscription subscriptionWithTitle:@"读书" codeName:@"dushu" hotSubs:NO newSubs:NO];
        XYSubscription *subs22 = [XYSubscription subscriptionWithTitle:@"艺术" codeName:@"Art" hotSubs:NO newSubs:NO];
        XYSubscription *subs23 = [XYSubscription subscriptionWithTitle:@"漫画" codeName:@"manhua" hotSubs:NO newSubs:NO];
        XYSubscription *subs24 = [XYSubscription subscriptionWithTitle:@"CBA" codeName:@"CBA" hotSubs:YES newSubs:NO];
        XYSubscription *subs25 = [XYSubscription subscriptionWithTitle:@"旅游" codeName:@"lvyou" hotSubs:NO newSubs:NO];
        
        unsubss = [NSMutableArray arrayWithObjects:subs1,subs2,subs3,subs4,subs5,subs6,subs7,subs8,subs9,subs10,subs11,subs12,subs13,subs14,subs15,subs16,subs17,subs18,subs19,subs20,subs21,subs22,subs23,subs24,subs25, nil];
        //保存到沙盒
        [self saveUnsubs:unsubss];
    }
    return unsubss;
}

/**
 *  保存未订阅的频道到沙盒
 *
 *  @param newSubss 新的未订阅频道数组
 */
+ (void)saveUnsubs:(NSMutableArray *)newUnsubss{
    NSMutableArray *tempA = [NSMutableArray array];
    for (XYSubscription *subs in newUnsubss) {
        NSData *subsData = [NSKeyedArchiver archivedDataWithRootObject:subs];
        [tempA addObject:subsData];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:tempA forKey:XYUnsubscriptions];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
