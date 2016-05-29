//
//  XYAlbum.m
//  XYNetEasyNews
//
//  Created by 李小亚 on 16/5/24.
//  Copyright © 2016年 李小亚. All rights reserved.
//

#import "XYAlbum.h"
#import "MJExtension.h"
#import "XYAlbumPhoto.h"

@implementation XYAlbum

- (NSDictionary *)objectClassInArray{
    return @{@"photos": [XYAlbumPhoto class]};
}

@end
