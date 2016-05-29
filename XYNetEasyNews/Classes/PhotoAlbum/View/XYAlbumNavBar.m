//
//  XYAlbumNavBar.m
//  XYNetEasyNews
//
//  Created by 李小亚 on 16/5/26.
//  Copyright © 2016年 李小亚. All rights reserved.
//

#import "XYAlbumNavBar.h"
#import "UIImage+XY.h"
#import "XYCommentStatistic.h"

@interface XYAlbumNavBar ()

@property (nonatomic, weak) UIButton *rightBtn;

@property (nonatomic, weak) UIButton *leftBtn;
@end

@implementation XYAlbumNavBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightBtn setBackgroundImage:[UIImage stretchableImage:[UIImage imageNamed:@"contentview_commentbacky"]] forState:UIControlStateNormal];
        [rightBtn setBackgroundImage:[UIImage stretchableImage:[UIImage imageNamed:@"contentview_commentbacky_selected"]] forState:UIControlStateHighlighted];
        rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        self.rightBtn = rightBtn;
        [self addSubview:rightBtn];
        [rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        
        UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.leftBtn = leftBtn;
        [self addSubview:leftBtn];
        [leftBtn setImage:[UIImage imageNamed:@"top_navigation_back"] forState:UIControlStateNormal];
        [leftBtn setImage:[UIImage imageNamed:@"icon_back_highlighted"] forState:UIControlStateHighlighted];
        [leftBtn sizeToFit];
        [leftBtn addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}


- (void)layoutSubviews{
    [super layoutSubviews];
    self.leftBtn.x = 1;
    self.leftBtn.y = (self.height - _leftBtn.height) / 2;
    
}

- (void)setCommentStatistic:(XYCommentStatistic *)commentStatistic{
    _commentStatistic = commentStatistic;
    NSString *title = [NSString stringWithFormat:@"%ld跟帖",_commentStatistic.votecount + _commentStatistic.prcount];
    [_rightBtn setTitle:title forState:UIControlStateNormal];

    [_rightBtn sizeToFit];
    _rightBtn.width += 20;
    _rightBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -7, 0, 0);
//    _rightBtn.backgroundColor = [UIColor orangeColor];
//    _rightBtn.titleLabel.backgroundColor = [UIColor purpleColor];
    
    self.rightBtn.x = self.width - _rightBtn.width - 5;
    self.rightBtn.y = (self.height - _rightBtn.height) / 2;
}

//返回上一个控制器
- (void)leftBtnClick{
    UINavigationController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController.childViewControllers[0];
    [rootVC popViewControllerAnimated:YES];
    //XYKeyWindow.rootViewController[0];
    
}

//
- (void)rightBtnClick{
    if ([self.delegate respondsToSelector:@selector(albumNavBarDidClickRightBtn:)]) {
        [self.delegate albumNavBarDidClickRightBtn:self];
        }
}
@end
