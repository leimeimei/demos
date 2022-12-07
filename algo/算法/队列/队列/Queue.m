//
//  Queue.m
//  队列
//
//  Created by sun on 2018/4/3.
//  Copyright © 2018年 sun. All rights reserved.
//

#import "Queue.h"

@interface Queue()
//使用数组模拟队列操作
@property (nonatomic, strong) NSMutableArray *data;

@end

@implementation Queue

- (instancetype)init {
    if (self = [super init]) {
        _data = [NSMutableArray array];
    }
    return self;
}

- (void)append:(NSString *)name {
    [self.data addObject:name];
}

- (NSString *)shift {
    
    if (self.data.count > 0) {
        NSString *result = self.data.firstObject;
        [self.data removeObjectAtIndex:0];
        return result;
    }
    return nil;
}

- (NSString *)front {
    return self.data.firstObject;
}

- (BOOL)isEmpty {
    return self.data.count == 0;
}

- (NSInteger)size {
    return self.data.count;
}

@end
