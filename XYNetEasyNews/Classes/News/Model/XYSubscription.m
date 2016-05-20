//
//  XYSubscription.m
//  XYNetEasyNews
//
//  Created by 李小亚 on 16/5/16.
//  Copyright © 2016年 李小亚. All rights reserved.
//

#import "XYSubscription.h"
#import <objc/runtime.h>

@implementation XYSubscription

- (instancetype)initWithTitle:(NSString *)title codeName:(NSString *)codeName hotSubs:(BOOL)hotSubs newSubs:(BOOL)newSubs{
    if (self = [super init]) {
        _title = title;
        _codeName = codeName;
        _hotSubs = hotSubs;
        _newSubs = newSubs;
    }
    return self;
}

+ (instancetype)subscriptionWithTitle:(NSString *)title codeName:(NSString *)codeName hotSubs:(BOOL)hotSubs newSubs:(BOOL)newSubs{
    return [[self alloc] initWithTitle:title codeName:codeName hotSubs:hotSubs newSubs:newSubs];
}


#pragma mark - 归档&解档
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
//    if (self = [super initWithCoder:aDecoder]) {
        unsigned int outCount = 0;
        Ivar *ivars = class_copyIvarList([self class], &outCount);
        
        for (int i = 0; i < outCount; i ++) {
            Ivar ivar = ivars[i];
            
            //将成员变量名转换为NSSting对象
            NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];
            //忽略不需要解档的属性
            if ([[self ignoredNames] containsObject:key]) {
                continue;
            }
            //根据变量名解档取值，无论是什么类型
            id value = [aDecoder decodeObjectForKey:key];
            //取出来的值再给属性赋值
            [self setValue:value forKey:key];
            
        }
        free(ivars);
        
//    }
    return self;
}


- (void)encodeWithCoder:(NSCoder *)aCoder{
    unsigned int outCount = 0;
    Ivar *ivars = class_copyIvarList([self class], &outCount);
    
    for (int i = 0; i < outCount; i ++) {
        Ivar ivar = ivars[i];
        //
        NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];
        
        if ([[self ignoredNames] containsObject:key]) {
            continue;
        }
        
        id value = [self valueForKey:key];
        
        [aCoder encodeObject:value forKey:key];
    }
    
    free(ivars);
    
}

//需要忽略的变量
- (NSArray *)ignoredNames{
    return nil;
}
@end
