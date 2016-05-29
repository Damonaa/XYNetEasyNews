//
//  XYShowPhotoView.m
//  XYNetEasyNews
//
//  Created by 李小亚 on 16/5/29.
//  Copyright © 2016年 李小亚. All rights reserved.
//

#define XYTitleFont [UIFont systemFontOfSize:12]

#import "XYShowPhotoView.h"
#import "UIImageView+WebCache.h"
#import "XYAlbum.h"

@interface XYShowPhotoView ()

@property (nonatomic, weak) UILabel *titleLable;

@end

@implementation XYShowPhotoView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.userInteractionEnabled = YES;
        //添加手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagImage:)];
        [self addGestureRecognizer:tap];
        
        UILabel *titleLable = [[UILabel alloc] init];
        self.titleLable = titleLable;
        [self addSubview:titleLable];
        titleLable.numberOfLines = 0;
        titleLable.font = XYTitleFont;
        titleLable.textColor = [UIColor whiteColor];
        titleLable.textAlignment = NSTextAlignmentLeft;
        titleLable.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.233];
        
    }
    return self;
}

- (void)setAlbum:(XYAlbum *)album{
    _album = album;
    //设置图片
    [self sd_setImageWithURL:[NSURL URLWithString:album.clientcover1] placeholderImage:[UIImage imageNamed:@"contentview_hd_loading_logo"]];
    
    
    _titleLable.text = album.setname;
    CGSize maxSize = CGSizeMake(self.width, MAXFLOAT);
    CGSize textSize = [album.setname boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: XYTitleFont} context:nil].size;
    [_titleLable sizeToFit];
    _titleLable.height = textSize.height;
    _titleLable.width = self.width;
    _titleLable.x = 0;
    _titleLable.y = self.height - _titleLable.height;
    
}

//点击图片，发出通知
- (void)tagImage:(UITapGestureRecognizer *)gesture{
    [[NSNotificationCenter defaultCenter] postNotificationName:XYTapReleatedAlbum object:nil userInfo:@{XYTapReleatedAlbum: _album}];
}
@end
