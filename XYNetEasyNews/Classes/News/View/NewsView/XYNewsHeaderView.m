//
//  XYNewsHeaderView.m
//  XYNetEasyNews
//
//  Created by 李小亚 on 16/5/22.
//  Copyright © 2016年 李小亚. All rights reserved.
//

#import "XYNewsHeaderView.h"
#import "XYAdItem.h"
#import "XYNewsItem.h"
#import "XYHeadImageView.h"

@interface XYNewsHeaderView ()<UIScrollViewDelegate>
/**
 *  视图浏览
 */
@property (nonatomic, weak) UIScrollView *scrollView;
/**
 *  page
 */
@property (weak, nonatomic) UIPageControl *pageControl;

/**
 *  定时器
 */
@property (nonatomic, strong) NSTimer *timer;
/**
 *  存放需要展示的图片信息
 */
@property (nonatomic, strong) NSMutableArray *imagesM;
@end

@implementation XYNewsHeaderView

- (NSMutableArray *)imagesM{
    if (!_imagesM) {
        _imagesM = [NSMutableArray array];
    }
    return _imagesM;
}

+ (instancetype)newsHeaderWithTableView:(UITableView *)tableView{
    static NSString *reuseID = @"newsHeader";
    XYNewsHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:reuseID];
    if (header == nil) {
        header = [[self alloc] initWithReuseIdentifier:reuseID];
    }
    return header;
}

//创建子控件，但是不设置frame
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self setupChildView];
        [self setTimer];
    }
    
    return self;
}

//添加子控件
- (void)setupChildView{
    //视图浏览
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    self.scrollView = scrollView;
    [self addSubview:scrollView];

    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.delegate = self;
    scrollView.bounces = NO;

    UIPageControl *pageControl = [[UIPageControl alloc] init];
    self.pageControl = pageControl;
    [self addSubview:pageControl];
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
}

- (void)setNewsItem:(XYNewsItem *)newsItem{
    _newsItem = newsItem;

    [self.imagesM removeAllObjects];
    //首页第一个图
    if (newsItem) {
        XYAdItem *adItem1 = [[XYAdItem alloc] init];
        adItem1.imgsrc = newsItem.img;
        adItem1.title = newsItem.title;
        adItem1.url = newsItem.photosetID;
        [self.imagesM addObject:adItem1];
    }
    
    //再添加3长
    for (int i = 0; i < 3; i ++) {
        XYAdItem *adItem = newsItem.ads[i];
        if ([adItem isKindOfClass:[XYAdItem class]]) {
            [self.imagesM addObject:adItem];
        }
    }
    //总展示的个数
    NSInteger imagesCount = self.imagesM.count;
    self.scrollView.contentSize = CGSizeMake(imagesCount * self.width, 0);
    //设置图片标题
    if (self.imagesM.count > 0) {
        for (int i = 0; i < imagesCount + 1; i ++) {
            XYHeadImageView *imageView = [[XYHeadImageView alloc] init];
            [self.scrollView addSubview:imageView];
            imageView.frame = CGRectMake(_scrollView.width * i, 0, _scrollView.width, _scrollView.height);
            
            //是否是第一个
            if (i == 0) {
                imageView.firstIV = YES;
            }else{
                imageView.firstIV = NO;
            }
            
            XYAdItem *adItem;
            if (i == imagesCount) {
                adItem = self.imagesM[0];
            }else{
                adItem = self.imagesM[i];
            }
            imageView.adItem = adItem;
            
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView:)];
            [imageView addGestureRecognizer:tap];
            
        }
        
        self.pageControl.numberOfPages = imagesCount;

    }

    
}
//布局子控件位置
- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.scrollView.frame = self.bounds;
    
    CGFloat pageW = 55;
    CGFloat pageH = 35;
    self.pageControl.frame = CGRectMake(_scrollView.width - pageW - 10, _scrollView.height - pageH, pageW, pageH);
    
}

- (void)setTimer{
    self.timer = [NSTimer timerWithTimeInterval:5 target:self selector:@selector(changeImage) userInfo:nil repeats:YES];
    
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    [runLoop addTimer:_timer forMode:NSRunLoopCommonModes];
    
}

#pragma mark - scroll view delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int page = (scrollView.contentOffset.x + scrollView.frame.size.width / 2) / scrollView.frame.size.width;
    if (page > _imagesM.count) {
        
    }else{
        self.pageControl.currentPage = page;
    }
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.timer invalidate];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self setTimer];
}
#pragma mark change image
- (void)changeImage{
    if (self.pageControl.currentPage == _imagesM.count - 1) {
        self.pageControl.currentPage = 0;
    }else{
        self.pageControl.currentPage ++;
        
    }
    
    CGFloat offserX = self.pageControl.currentPage * self.scrollView.frame.size.width;
    
    [UIView animateWithDuration:2 animations:^{
        [self.scrollView setContentOffset:CGPointMake(offserX, 0) animated:YES];
    }];
}

#pragma mark - 处理手势，响应代理
- (void)tapImageView:(UITapGestureRecognizer *)gesture{
    XYHeadImageView *headIV = (XYHeadImageView *)gesture.view;
    if ([self.delegate respondsToSelector:@selector(newsHeaderViewDidTapImage:adItem:)]) {
        [self.delegate newsHeaderViewDidTapImage:self adItem:headIV.adItem];
    }
}
@end
