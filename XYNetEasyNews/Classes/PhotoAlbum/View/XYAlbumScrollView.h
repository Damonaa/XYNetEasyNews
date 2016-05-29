//
//  XYAlbumScrollView.h
//  XYNetEasyNews
//
//  Created by 李小亚 on 16/5/25.
//  Copyright © 2016年 李小亚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYAlbum.h"

@class XYAlbumScrollView;

@protocol XYAlbumScrollViewDelegate <NSObject>

- (void)albumScrollViewAtLastPage:(XYAlbumScrollView *)albumScrollView;
- (void)albumScrollViewNotAtLastPage:(XYAlbumScrollView *)albumScrollView;
@end


typedef void(^AlbumScrollIndexBlock)(NSInteger index);

@interface XYAlbumScrollView : UIScrollView
/**
 *  图集
 */
@property (nonatomic, strong) XYAlbum *album;


@property (nonatomic, copy) AlbumScrollIndexBlock albumScrollIndex;

/**
 *  相关图集的信息
 */
@property (nonatomic, strong) NSArray *relatedArray;

@property (nonatomic, weak) id<XYAlbumScrollViewDelegate> albumDelegate;
@end
