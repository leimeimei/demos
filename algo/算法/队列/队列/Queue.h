//
//  Queue.h
//  队列
//
//  Created by sun on 2018/4/3.
//  Copyright © 2018年 sun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Queue : NSObject
//为了方便举例子，队列中存储字符串
- (void)append:(NSString *)name;
//移除队首元素
- (NSString *)shift;

- (NSString *)front;

- (BOOL)isEmpty;

- (NSInteger)size;

@end
