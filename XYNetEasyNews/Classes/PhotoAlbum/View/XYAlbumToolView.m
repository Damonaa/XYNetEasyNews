//
//  XYAlbumToolView.m
//  XYNetEasyNews
//
//  Created by 李小亚 on 16/5/25.
//  Copyright © 2016年 李小亚. All rights reserved.
//

#import "XYAlbumToolView.h"
#import "XYCommentStatistic.h"
#import "XYWriteButton.h"

@interface XYAlbumToolView ()
/**
 *  写跟帖
 */
@property (nonatomic, weak) UIButton *writeBtn;
/**
 *  跟帖内容
 */
@property (nonatomic, weak) UIButton *followBtn;
/**
 *  分享
 */
@property (nonatomic, weak) UIButton *shareBtn;
/**
 *  更多选项按钮
 */
@property (nonatomic, weak) UIButton *moreBtn;
@end

@implementation XYAlbumToolView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupChildView];
        self.backgroundColor = [UIColor blackColor];
    }
    return self;
}
//添加子控件
- (void)setupChildView{
    //写跟帖
    XYWriteButton *writeBtn = [XYWriteButton buttonWithType:UIButtonTypeCustom];
    self.writeBtn = writeBtn;
    [self addSubview:writeBtn];
    writeBtn.tag = 0;
    
    
    //跟帖内容
    UIButton *followBtn = [UIButton buttonWithNormalImage:[UIImage imageNamed:@"toolbar_commentbutton"] highlightedImage:nil target:self selcetor:@selector(commentToolClick:) controlEvent:UIControlEventTouchUpInside];
    followBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    self.followBtn = followBtn;
    [self addSubview:followBtn];
    followBtn.tag = 1;
    
    //分享按钮
    UIButton *shareBtn = [UIButton buttonWithNormalImage:[UIImage imageNamed:@"reader_share"] highlightedImage:[UIImage imageNamed:@"reader_share_highlight"] target:self selcetor:@selector(commentToolClick:) controlEvent:UIControlEventTouchUpInside];
    self.shareBtn = shareBtn;
    [self addSubview:shareBtn];
    shareBtn.tag = 2;
    
    //更多
    UIButton *moreBtn = [UIButton buttonWithNormalImage:[UIImage imageNamed:@"readercell_more"] highlightedImage:[UIImage imageNamed:@"readercell_more_highlighted"] target:self selcetor:@selector(commentToolClick:) controlEvent:UIControlEventTouchUpInside];
    self.moreBtn = moreBtn;
    [self addSubview:moreBtn];
    moreBtn.tag = 3;
}

//布局子控件位置
- (void)setCommentStatistic:(XYCommentStatistic *)commentStatistic{
    _commentStatistic = commentStatistic;
    
    //设置跟帖数目
    [self.followBtn setTitle:[NSString stringWithFormat:@"%ld", commentStatistic.votecount + commentStatistic.prcount] forState:UIControlStateNormal];
    [self.followBtn sizeToFit];

    //布局
    CGFloat margin = 10;
    
    _moreBtn.x = self.width - margin - _moreBtn.width;
    _moreBtn.y = (self.height - _moreBtn.height) / 2;
    
    _shareBtn.x =  _moreBtn.x - margin - _shareBtn.width;
    _shareBtn.y = (self.height - _shareBtn.height) / 2;;
    
    _followBtn.x = _shareBtn.x - margin - _followBtn.width;
    _followBtn.y = (self.height - _followBtn.height) / 2;;
    
    _writeBtn.height -= 5;
    _writeBtn.x = margin;
    _writeBtn.y = (self.height - _writeBtn.height) / 2;
    _writeBtn.width = _followBtn.x - margin * 2;
    
}



//响应按钮的点击
- (void)commentToolClick:(UIButton *)button{
    
}
@end
