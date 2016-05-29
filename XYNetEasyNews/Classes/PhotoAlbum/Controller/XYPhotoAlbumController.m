//
//  XYPhotoAlbumController.m
//  XYNetEasyNews
//
//  Created by 李小亚 on 16/5/24.
//  Copyright © 2016年 李小亚. All rights reserved.
//

#define XYNoteVisulaH 120
#define XYNoteViewY XYScreenHeight - 64 - 35 - XYNoteVisulaH

#import "XYPhotoAlbumController.h"
#import "XYCommentStatistic.h"

#import "XYAlbumNavBar.h"
#import "XYAlbumScrollView.h"
#import "XYAlbumToolView.h"
#import "XYNoteView.h"
#import "XYAdItem.h"
#import "XYHttpTool.h"
#import "XYAlbum.h"
#import "XYAlbumPhoto.h"
#import "MJExtension.h"

@interface XYPhotoAlbumController ()<XYAlbumNavBarDelegate, XYAlbumScrollViewDelegate>
/**
 *  顶部导航栏
 */
@property (nonatomic, weak) XYAlbumNavBar *albumNavBar;
/**
 *  图片展示的scrollView
 */
@property (nonatomic, weak) XYAlbumScrollView *albumScrollView;
/**
 *  图片注释noteView
 */
@property (nonatomic, weak) XYNoteView *noteView;
/**
 *  工具栏
 */
@property (nonatomic, weak) XYAlbumToolView *albumToolView;

@end

@implementation XYPhotoAlbumController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    //添加子控件
    [self setupChildView];
    //监听相关的图集的点击
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tapAlbum:) name:XYTapReleatedAlbum object:nil];

}

- (void)setupChildView{
    //顶部自定义的导航栏
    XYAlbumNavBar *albumNavBar = [[XYAlbumNavBar alloc] initWithFrame:CGRectMake(0, 20, XYScreenWidth, 44)];
    self.albumNavBar = albumNavBar;
    [self.navigationController.view addSubview:albumNavBar];
    albumNavBar.commentStatistic = nil;
    albumNavBar.delegate = self;
    
    //图片展示的scrollView
    XYAlbumScrollView *albumScrollView = [[XYAlbumScrollView alloc] init];
    [self.view addSubview:albumScrollView];
    self.albumScrollView = albumScrollView;
    albumScrollView.width = XYScreenWidth;
    albumScrollView.height = XYScreenWidth + 100;//XYScreenHeight - 64 - 35;
    albumScrollView.x = 0;
    albumScrollView.y = (XYScreenHeight - 64 - albumScrollView.height) / 2 - 64;
//    albumScrollView.backgroundColor = [UIColor redColor];
    
    __weak typeof(self) weakSelf = self;
    _albumScrollView.albumScrollIndex = ^(NSInteger index){
        //传递当前滚动到的页码
        weakSelf.noteView.currentIndex = index;
        weakSelf.noteView.y = XYNoteViewY;//CGRectGetMaxY(albumScrollView.frame) + 40;
    };
    albumScrollView.albumDelegate = self;
    
    //图片注释noteView
    XYNoteView *noteView = [[XYNoteView alloc] init];
    [self.view addSubview:noteView];
    self.noteView = noteView;
    noteView.width = XYScreenWidth;
//    _noteView.height = 150;
    noteView.x = 0;
    noteView.y = XYNoteViewY;//CGRectGetMaxY(albumScrollView.frame) + 40;
    //添加拖动手势
    UIPanGestureRecognizer *panNote = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panNoteView:)];
    [noteView addGestureRecognizer:panNote];
    
    //工具栏
    XYAlbumToolView *albumToolView = [[XYAlbumToolView alloc] init];
    [self.view addSubview:albumToolView];
    self.albumToolView = albumToolView;
    albumToolView.width = XYScreenWidth;
    albumToolView.height = 35;
    albumToolView.x = 0;
    albumToolView.y = XYScreenHeight - 35 - 64;
}

- (void)setAdItem:(XYAdItem *)adItem{
    _adItem = adItem;
    /**
     *  //相关的图集 + url的后半段
     //http://c.m.163.com/photo/api/related/0001/119318.json
     //评论
     //http://comment.api.163.com/api/json/thread/total/news_guonei8_bbs/BNRLIMN40001124J
     //评论个数 + postid
     //http://comment.api.163.com/api/json/thread/total/photoview_bbs/PHOT3KGM000100AP
     */
    NSString *urlStr = adItem.url;
    NSRange range = [urlStr rangeOfString:@"|"];
    NSString *single = [urlStr substringFromIndex:range.location + 1];
    urlStr = [NSString stringWithFormat:@"http://c.m.163.com/photo/api/set/0001/%@.json",single];
    [XYHttpTool GET:urlStr parameters:nil success:^(id responseObject) {
//        XYLog(@"%@", responseObject);
        XYAlbum *album = [XYAlbum objectWithKeyValues:responseObject];

        self.noteView.album = album;
        self.noteView.currentIndex = 0;
        self.albumScrollView.album = album;
        
        //相关图集数据
        NSString *relatedUrl = [NSString stringWithFormat:@"http://c.m.163.com/photo/api/related/0001/%@.json",single];
        [XYHttpTool GET:relatedUrl parameters:nil success:^(id responseObject) {
            XYLog(@"relatedUrl%@", responseObject);
            NSArray *temp = [XYAlbum objectArrayWithKeyValuesArray:responseObject];

            _albumScrollView.relatedArray = temp;
        } failure:^(NSError *error) {
            XYLog(@"relatedUrl - %@", error);
        }];
        
        //评论数据
        NSString *appendID = album.postid ? album.postid : album.setid;
        NSString *commentCountUrl = [NSString stringWithFormat:@"http://comment.api.163.com/api/json/thread/total/photoview_bbs/%@", appendID];
        
        [XYHttpTool GET:commentCountUrl parameters:nil success:^(id responseObject) {
//            XYLog(@"commentCountUrl - %@", responseObject);
            XYCommentStatistic *comStat = [XYCommentStatistic objectWithKeyValues:responseObject];
            self.albumNavBar.commentStatistic = comStat;
            self.albumToolView.commentStatistic = comStat;
            
        } failure:^(NSError *error) {
            XYLog(@"commentCountUrl - %@", error);
        }];
        
    } failure:^(NSError *error) {
        XYLog(@"%@", error);
    }];

}

#pragma mark - XYAlbumNavBarDelegate
- (void)albumNavBarDidClickRightBtn:(XYAlbumNavBar *)albumNavBar{
    
}

#pragma mark - 处理拖拽noteView的手势
- (void)panNoteView:(UIPanGestureRecognizer *)gesture{
    
    CGPoint tran = [gesture translationInView:gesture.view];
    
    
    //判断是否需要移动
//    CGFloat photoViewMaxY = CGRectGetMaxY(_albumScrollView.frame) + 40;
//    CGFloat albumToolMinY = CGRectGetMinY(_albumToolView.frame) - 5;
    
    CGFloat minY = XYScreenHeight - _albumToolView.height - _noteView.height - 10 - 64;
    //可展示的空间
//    CGFloat deltaY = 150;//= albumToolMinY - photoViewMaxY;
    if (_noteView.height > XYNoteVisulaH ) { ////文本信息被遮盖
        if (gesture.state == UIGestureRecognizerStateChanged) {//在滑动
            if (tran.y < 0) {//向上
                [UIView animateWithDuration:0.2 animations:^{
                    if (_noteView.y < minY) {//文本已经完全展示
                        self.noteView.transform = CGAffineTransformTranslate(_noteView.transform, 0, tran.y * 0.1);
                    }else{//文本还未完全展示
                        self.noteView.transform = CGAffineTransformTranslate(_noteView.transform, 0, tran.y);
                        
                    }
                    [gesture setTranslation:CGPointZero inView:gesture.view];
                }];
            }else{//向下， 复位
                [UIView animateWithDuration:0.2 animations:^{
                    _noteView.y = XYNoteViewY;
                }];
            }
            
        }else if(gesture.state == UIGestureRecognizerStateEnded){//结束滑动
            [UIView animateWithDuration:0.2 animations:^{
                if (tran.y > 0) {//向下
                    _noteView.y = XYNoteViewY;//photoViewMaxY;
                }else{//向上
                    _noteView.y = minY;
                }
                
            }];
        }

    }else{//文本信息未被遮盖
        if (gesture.state == UIGestureRecognizerStateChanged) {//在滑动
            [UIView animateWithDuration:0.2 animations:^{
                CGFloat moveY = tran.y > 0 ? 10 : -10;
                _noteView.transform = CGAffineTransformMakeTranslation(0, moveY);
            }];
        }else if(gesture.state == UIGestureRecognizerStateEnded){//结束滑动

            [UIView animateWithDuration:0.2 animations:^{

                _noteView.transform = CGAffineTransformIdentity;
            }];
        }
    }
    
}

#pragma mark - XYAlbumScrollViewDelegate
//最后一页
- (void)albumScrollViewAtLastPage:(XYAlbumScrollView *)albumScrollView{
    [UIView animateWithDuration:0.1 animations:^{
        _albumToolView.alpha = 0;
        _noteView.alpha = 0;
    }];
}
//不在最后一页
- (void)albumScrollViewNotAtLastPage:(XYAlbumScrollView *)albumScrollView{
    [UIView animateWithDuration:0.1 animations:^{
        _albumToolView.alpha = 1;
        _noteView.alpha = 1;
    }];
}

#pragma mark - 响应相关图集的点击
- (void)tapAlbum:(NSNotification *)noti{
    XYAlbum *album = noti.userInfo[XYTapReleatedAlbum];
    XYLog(@"%@", album.setname);
    
//    XYPhotoAlbumController *pav = [[XYPhotoAlbumController alloc] init];
    
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
//// 隐藏状态栏
//- (BOOL)prefersStatusBarHidden{
//    return YES;
//}
@end
