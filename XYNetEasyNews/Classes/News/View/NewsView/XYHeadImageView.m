//
//  XYHeadImageView.m
//  XYNetEasyNews
//
//  Created by 李小亚 on 16/5/23.
//  Copyright © 2016年 李小亚. All rights reserved.
//

#import "XYHeadImageView.h"
#import "XYAdItem.h"
#import "UIImageView+WebCache.h"

@interface XYHeadImageView ()
/**
 *  展示图片
 */
@property (nonatomic, weak) UIImageView *showImages;
/**
 *  底部容器
 */
@property (nonatomic, weak) UIView *bottomContainer;
/**
 *  图集标志，仅仅显示在第一个页面
 */
@property (nonatomic, weak) UIButton *imageIcon;
/**
 *  标题
 */
@property (nonatomic, weak) UILabel *titleLabel;
/**
 *  图片类型（图集，广告推广）
 */
@property (nonatomic, weak) UIImageView *imageType;
@end

@implementation XYHeadImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupChildView];
        self.userInteractionEnabled = YES;
        
    }
    return self;
}
//添加子控件
- (void)setupChildView{
    
    UIImageView *showImages = [[UIImageView alloc] init];
    [self addSubview:showImages];
    self.showImages = showImages;
    
    //底部容器
    UIView *bottomContainer = [[UIView alloc] init];
    self.bottomContainer = bottomContainer;
    [self addSubview:bottomContainer];
    bottomContainer.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.149];
    
    UIButton *imageIcon = [UIButton buttonWithType:UIButtonTypeCustom];
    self.imageIcon = imageIcon;
    [self.bottomContainer addSubview:imageIcon];
    [imageIcon setBackgroundImage:[UIImage imageNamed:@"head_news_cell_category_background"] forState:UIControlStateNormal];
    [imageIcon setTitle:@"图集" forState:UIControlStateNormal];
    [imageIcon setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    imageIcon.titleLabel.font = [UIFont systemFontOfSize:15];
    imageIcon.enabled = NO;
    [imageIcon sizeToFit];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    self.titleLabel = titleLabel;
    [self.bottomContainer addSubview:titleLabel];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    
    UIImageView *imageType = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_composer_image_select"]];
    self.imageType = imageType;
    [self.bottomContainer addSubview:imageType];
    
}

- (void)setAdItem:(XYAdItem *)adItem{
    _adItem = adItem;
    
    //赋值
    [_showImages sd_setImageWithURL:[NSURL URLWithString:adItem.imgsrc] placeholderImage:[UIImage imageNamed:@"photoview_image_default_hd"]];
    self.titleLabel.text = adItem.title;
    [_titleLabel sizeToFit];
    //frame
    _showImages.frame = self.bounds;
    //底部容器
    CGFloat bottomH = 35;
    _bottomContainer.frame = CGRectMake(0, self.height - bottomH, self.width, bottomH);
    
    //图集标志
    if (self.isFirstIV) {//是第一个
        self.imageIcon.hidden = NO;
        self.imageIcon.y = -3;
        self.imageIcon.height += 4;
        //标题
        self.titleLabel.x = CGRectGetMaxX(_imageIcon.frame) + 5;
        
    }else{
        self.imageIcon.hidden = YES;
        self.titleLabel.x = 5;
    }
    
    self.titleLabel.y = (_bottomContainer.height - _titleLabel.height) / 2;
    
    //类型
    self.imageType.x = CGRectGetMaxX(_titleLabel.frame) + 10;
    self.imageType.y = (_bottomContainer.height - _imageType.height) / 2;
}
//布局子控件位置

@end
