//
//  XYNewsContainerView.h
//  XYNetEasyNews
//
//  Created by 李小亚 on 16/5/22.
//  Copyright © 2016年 李小亚. All rights reserved.
//

#import <UIKit/UIKit.h>

//@class XYNews;

typedef void(^NewsContainerGetBlock)(NSInteger newsCount);

@interface XYNewsContainerView : UIScrollView

@property (nonatomic, copy) NewsContainerGetBlock newsContainerGet;

/**
 *  全部的新闻数据
 */
//@property (nonatomic, strong) XYNews *news;

@end
