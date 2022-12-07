//
//  MyArray.m
//  数据结构与算法
//
//  Created by sun on 2019/3/4.
//  Copyright © 2019 sun. All rights reserved.
//

#import "MyArray.h"

@interface MyArray()

@property (nonatomic, strong) NSMutableArray *arr;
@property (nonatomic, assign) NSUInteger capacity;
@property (nonatomic, assign) NSUInteger count;

@end

@implementation MyArray

- (instancetype)initWithCapacity:(NSUInteger)capacity {
    if (self = [super init]) {
        self.arr = [NSMutableArray arrayWithCapacity:capacity];
        self.capacity = capacity;
        self.count = 0;
    }
    return self;
}
- (id)objectAtIndex:(NSUInteger)index {
    if (index > self.capacity) {
        [NSException raise:NSRangeException format:@"out of range!"];
    }
    return self.arr[index];
}
- (void)removeObjectAtIndex:(NSUInteger)index {
    if (index > self.capacity || _count == 0) {
        [NSException raise:NSRangeException format:@"out of range!"];
    }
    for (NSUInteger i = index + 1; i < _count; ++i) {
        _arr[i-1] = _arr[i];
    }
    _count--;
    
}
- (void)insertObject:(id)object At:(NSUInteger)index {
    if (index >= _count || _count == _capacity) {
        [NSException raise:NSRangeException format:@"out of range!"];
    }
    for (NSUInteger i = _count - 1; i > 0; --i) {
        _arr[i+1] = _arr[i];
    }
    _arr[index] = object;
    _count++;
}
- (void)addObject:(id)object {
    if (self.count >= self.capacity) {
        [NSException raise:NSRangeException format:@"array is full!"];
    }
    _arr[_count++] = object;
}
- (NSUInteger)count {
    return _count;
}
- (void)print {
    for (NSUInteger i = 0; i < _count; ++i) {
        NSLog(@"%@",_arr[i]);
    }
}

@end
