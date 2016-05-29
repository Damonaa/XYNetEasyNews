//
//  XYAlbumNavBar.h
//  XYNetEasyNews
//
//  Created by 李小亚 on 16/5/26.
//  Copyright © 2016年 李小亚. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XYCommentStatistic, XYAlbumNavBar;

@protocol XYAlbumNavBarDelegate <NSObject>

- (void)albumNavBarDidClickRightBtn:(XYAlbumNavBar *)albumNavBar;

@end

@interface XYAlbumNavBar : UIView

@property (nonatomic, strong) XYCommentStatistic *commentStatistic;

@property (nonatomic, weak) id<XYAlbumNavBarDelegate> delegate;

@end
