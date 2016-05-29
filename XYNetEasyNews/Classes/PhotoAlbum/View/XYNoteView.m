//
//  XYNoteView.m
//  XYNetEasyNews
//
//  Created by 李小亚 on 16/5/25.
//  Copyright © 2016年 李小亚. All rights reserved.
//


#define XYNoteLabelFont [UIFont systemFontOfSize:13]

#import "XYNoteView.h"
#import "XYAlbum.h"
#import "XYAlbumPhoto.h"

@interface XYNoteView ()
/**
 *  标题
 */
@property (nonatomic, weak) UILabel *titleLable;
/**
 *  索引页码
 */
@property (nonatomic, weak) UILabel *indexLabel;
/**
 *  图片解释
 */
@property (nonatomic, weak) UILabel *noteLabel;
@end

@implementation XYNoteView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupChildView];
        self.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.278];
    }
    return self;
}
//添加子控件
- (void)setupChildView{
    //标题
    UILabel *titleLable = [[UILabel alloc] init];
    self.titleLable = titleLable;
    [self addSubview:titleLable];
    titleLable.font = [UIFont systemFontOfSize:16];
    titleLable.textColor = [UIColor whiteColor];

    //索引
    UILabel *indexLabel = [[UILabel alloc] init];
    self.indexLabel = indexLabel;
    [self addSubview:indexLabel];
    indexLabel.textColor = [UIColor whiteColor];
    indexLabel.font = [UIFont systemFontOfSize:11];
    //内容
    UILabel *noteLabel = [[UILabel alloc] init];
    self.noteLabel = noteLabel;
    [self addSubview:noteLabel];
    noteLabel.textColor = [UIColor whiteColor];
    noteLabel.numberOfLines = 0;
    noteLabel.font = XYNoteLabelFont;
    
}
//布局子控件位置
//赋值
- (void)setAlbum:(XYAlbum *)album{
    _album = album;
    
    CGFloat margin = 5;
    //标题
    _titleLable.text = album.setname;
    [_titleLable sizeToFit];
    _titleLable.x = margin;
    _titleLable.y = margin;
    //索引
    _indexLabel.text = [NSString stringWithFormat:@"%ld/%ld", _currentIndex, album.imgsum];
    [_indexLabel sizeToFit];
    
    _indexLabel.x = self.width - _indexLabel.width - margin;
    _indexLabel.y = margin;
}
//note 解释
- (void)setCurrentIndex:(NSInteger)currentIndex{
    _currentIndex = currentIndex;
    
    if (currentIndex >= _album.photos.count) {
        return;
    }
    
    _indexLabel.text = [NSString stringWithFormat:@"%ld/%ld", _currentIndex + 1, _album.imgsum];
    [_indexLabel sizeToFit];
    XYAlbumPhoto *albumPhoto = _album.photos[currentIndex];
    
    CGSize maxSize = CGSizeMake(XYScreenWidth - 10, MAXFLOAT);
    CGSize noteSize = [albumPhoto.note boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:XYNoteLabelFont} context:nil].size;
    _noteLabel.frame = (CGRect){{5, CGRectGetMaxY(_titleLable.frame)+5}, noteSize};
    
    _noteLabel.text = albumPhoto.note;
    //设置父控件的高度
    self.height = CGRectGetMaxY(_noteLabel.frame);
    
//    self.contentSize = CGSizeMake(0, CGRectGetMaxY(_noteLabel.frame));
//    XYLog(@"%@", albumPhoto.note);
}




@end
