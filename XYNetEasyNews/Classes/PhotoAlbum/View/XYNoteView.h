//
//  XYNoteView.h
//  XYNetEasyNews
//
//  Created by 李小亚 on 16/5/25.
//  Copyright © 2016年 李小亚. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XYAlbum, XYAlbumPhoto;


@interface XYNoteView : UIView
/**
 *  图集存放全部数据
 */
@property (nonatomic, strong) XYAlbum *album;
/**
 *  一个相片的信息
 */
//@property (nonatomic, strong) XYAlbumPhoto *albumPhoto;
/**
 *  当前索引
 */
@property (nonatomic, assign) NSInteger currentIndex;


@end
