//
//  MyArray.h
//  数据结构与算法
//
//  Created by sun on 2019/3/4.
//  Copyright © 2019 sun. All rights reserved.
//

#import <Foundation/Foundation.h>
// 自定义数组
NS_ASSUME_NONNULL_BEGIN

@interface MyArray : NSObject

- (instancetype)initWithCapacity:(NSUInteger)capacity;
- (id)objectAtIndex:(NSUInteger)index;
- (void)removeObjectAtIndex:(NSUInteger)index;
- (void)insertObject:(id)object At:(NSUInteger)index;
- (void)addObject:(id)object;
- (NSUInteger)count;
- (void)print;

@end

NS_ASSUME_NONNULL_END
