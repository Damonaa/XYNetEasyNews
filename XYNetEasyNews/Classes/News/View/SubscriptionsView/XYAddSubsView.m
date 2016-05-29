//
//  XYAddSubsView.m
//  XYNetEasyNews
//
//  Created by 李小亚 on 16/5/17.
//  Copyright © 2016年 李小亚. All rights reserved.
//

#import "XYAddSubsView.h"


@interface XYAddSubsView ()
//遮盖用的背景
@property (nonatomic, weak) UIView *coverView;
/**
 *  渐变色
 */
@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@end

@implementation XYAddSubsView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupChildView];
        
    }
    return self;
}
//添加子控件
- (void)setupChildView{

    //设置渐变色
    self.gradientLayer = [CAGradientLayer layer];
    
    self.gradientLayer.startPoint = CGPointMake(0, 0);
    self.gradientLayer.endPoint = CGPointMake(1, 0);
    self.gradientLayer.colors = @[(__bridge id)XYSubsBGColorAlpha.CGColor, (__bridge id)XYSubsBGColor.CGColor];
    [self.layer addSublayer:self.gradientLayer];
    
    
    UIView *coverView = [[UIView alloc] init];
    [self addSubview:coverView];
    self.coverView = coverView;
    coverView.backgroundColor = XYSubsBGColor;
    
}
//布局子控件位置
- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.coverView.height = self.height;
    self.coverView.width = self.height;
    self.coverView.x = self.width - self.coverView.width;
    self.coverView.y = 0;
    
    self.gradientLayer.frame = CGRectMake(0, 0, self.width - self.coverView.width, self.height);
}

@end
