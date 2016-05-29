//
//  XYAlbumScrollView.m
//  XYNetEasyNews
//
//  Created by 李小亚 on 16/5/25.
//  Copyright © 2016年 李小亚. All rights reserved.
//

#import "XYAlbumScrollView.h"
#import "XYAlbum.h"
#import "XYAlbumPhoto.h"
#import "UIImageView+WebCache.h"
#import "XYHttpTool.h"
#import "XYRelatedView.h"

@interface XYAlbumScrollView ()<UIScrollViewDelegate>
/**
 *  存放全部的photos
 */
@property (nonatomic, strong) NSMutableArray *photoViews;
/**
 *  当前可见的imageView
 */
@property (nonatomic, strong) UIImageView *visualImageView;
/**
 *  重用的imageView
 */
@property (nonatomic, strong) UIImageView *reusedImageView;
@end

@implementation XYAlbumScrollView

- (NSMutableArray *)photoViews{
    if (!_photoViews) {
        _photoViews = [NSMutableArray array];
    }
    return _photoViews;
}

- (UIImageView *)visualImageView{
    if (!_visualImageView) {
        _visualImageView = [[UIImageView alloc] init];
        [self addSubview:_visualImageView];
        _visualImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _visualImageView;
}
- (UIImageView *)reusedImageView{
    if (!_reusedImageView) {
        _reusedImageView = [[UIImageView alloc] init];
        [self addSubview:_reusedImageView];
        _reusedImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _reusedImageView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        [self setupChildView];
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.pagingEnabled = YES;
        self.delegate = self;
        
    }
    return self;
}

//添加图片视图
- (void)setAlbum:(XYAlbum *)album{
    _album = album;
    
    NSArray *photos = album.photos;
    NSInteger photosCount = photos.count;
    self.contentSize = CGSizeMake(XYScreenWidth * (photosCount + 1) , 0);
    //添加当前视图
    self.visualImageView.frame = self.bounds;
    
    XYAlbumPhoto *albumPhoto = album.photos[0];
    [_visualImageView sd_setImageWithURL:[NSURL URLWithString:albumPhoto.imgurl] placeholderImage:[UIImage imageNamed:@"contentview_hd_loading_logo"]];
    
    
    
}
#pragma mark - scroll view delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSArray *photos = _album.photos;
    NSInteger photosCount = photos.count;
    //如果仅有一张，返回，不做处理
    if (photosCount < 2) {//有大于一张图片
        return;
    }
    //是否是向右滑动
    BOOL scrollToRigth = [self scrollToRigthWithScrollView:scrollView];
    //将要过渡到的页面
    static int currentPage;
    static int nextPageOld;
    static int nextPageNew;
    //计算当前页码和将要过渡到的页码
    if (scrollToRigth) {//向右
        currentPage = scrollView.contentOffset.x / scrollView.width;
        nextPageNew = (scrollView.contentOffset.x + scrollView.width) / scrollView.width;
    }else{
        nextPageNew = scrollView.contentOffset.x / scrollView.width;
        currentPage = (scrollView.contentOffset.x + scrollView.width) / scrollView.width;
    }
    
    //将重用的图片放到将要过渡到的界面中
    if (nextPageNew != nextPageOld) {
        if (nextPageNew < photosCount && nextPageNew >= 0) {//不是最后一页
            [self setupImageViewWithImageView:self.reusedImageView index:nextPageNew];
            [self setupImageViewWithImageView:self.visualImageView index:currentPage];
        }
        nextPageOld = nextPageNew;
        //进入新的页面，回调
        if (_albumScrollIndex) {
            _albumScrollIndex(currentPage);
        }
    }
    
    
    //如果是最后一页.响应代理
    if (currentPage == photosCount) {
        if ([self.albumDelegate respondsToSelector:@selector(albumScrollViewAtLastPage:)]) {
            [self.albumDelegate albumScrollViewAtLastPage:self];
        }
    }else{
        if ([self.albumDelegate respondsToSelector:@selector(albumScrollViewNotAtLastPage:)]) {
            [self.albumDelegate albumScrollViewNotAtLastPage:self];
        }
    }
}

//设置重用图片视图的frame以及图片
- (void)setupImageViewWithImageView:(UIImageView *)imageView index:(int)indexPage{
    imageView.frame = CGRectMake(self.width * indexPage, 0, self.width, self.height);
    XYAlbumPhoto *albumPhoto = _album.photos[indexPage];
    [imageView sd_setImageWithURL:[NSURL URLWithString:albumPhoto.imgurl] placeholderImage:[UIImage imageNamed:@"contentview_hd_loading_logo"]];
    
}

//判断向左还是向右滑动
- (BOOL)scrollToRigthWithScrollView:(UIScrollView *)scrollView{
    static float newX = 0;
    static float oldX = 0;
    newX = scrollView.contentOffset.x;
    if (newX != oldX) {
        if (newX > oldX) {//向右
            return YES;
        }else if (newX < oldX){//向左滚动
            return NO;
        }
        oldX = newX;
    }
    return YES;
}

//相关图集赋值
- (void)setRelatedArray:(NSArray *)relatedArray{
    _relatedArray = relatedArray;
    
    
    XYRelatedView *relatedView = [[XYRelatedView alloc] init];
    [self addSubview:relatedView];
    relatedView.albums = relatedArray;
    
    relatedView.bounds = self.bounds;
    relatedView.x = XYScreenWidth * _album.imgsum;
    relatedView.y = 0;
    
    
//    for (XYAlbum *album in relatedArray) {
//        XYLog(@"%@", album.clientcover1);
//    }
}


@end
