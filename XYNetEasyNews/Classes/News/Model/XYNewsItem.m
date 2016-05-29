//
//  XYNewsItem.m
//  XYNetEasyNews
//
//  Created by 李小亚 on 16/5/22.
//  Copyright © 2016年 李小亚. All rights reserved.
//

#import "XYNewsItem.h"
#import "XYAdItem.h"
#import "MJExtension.h"

@implementation XYNewsItem

- (NSDictionary *)objectClassInArray{
    return @{@"ads":[XYAdItem class]};
}

@end
