//
//  XYAlbumPhoto.h
//  XYNetEasyNews
//
//  Created by 李小亚 on 16/5/24.
//  Copyright © 2016年 李小亚. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface XYAlbumPhoto : NSObject
/**
 
 *  {
 "timgurl": "http://img3.cache.netease.com/photo/0001/2016-05-24/t_BNRM5PNQ00AP0001.png",
 "photohtml": "http://news.163.com/photoview/00AP0001/119318.html#p=BNRM5PNQ00AP0001",
 "newsurl": "#",
 "squareimgurl": "http://img4.cache.netease.com/photo/0001/2016-05-24/400x400_BNRM5PNQ00AP0001.png",
 "cimgurl": "http://img3.cache.netease.com/photo/0001/2016-05-24/c_BNRM5PNQ00AP0001.png",
 "imgtitle": "",
 "simgurl": "http:img3.cache.netease.com/photo/0001/2016-05-24/s_BNRM5PNQ00AP0001.png",
 "note": "5月24日上午十点多，湖南，一上身赤裸的男子爬上长沙五一大道与黄兴路交汇的高架桥交通信号灯上，欲跳下轻生，造成严重的交通拥堵。最后，该男子试图从灯上返回桥上时失手摔下，掉在了安全气垫之外，目前已被警方送往医院救治。图为现场，救援人员试图用管子敲打男子，让其跳在安全气垫上。（来源：新湖南客户端，头条新闻官微）",
 "photoid": "BNRM5PNQ00AP0001",
 "imgurl": "http:img4.cache.netease.com/photo/0001/2016-05-24/BNRM5PNQ00AP0001.png"
	}
 */
/**
*  图片注释
*/
@property (nonatomic, copy) NSString *note;
/**
 *  图片URL
 */
@property (nonatomic, copy) NSString *imgurl;
@end
