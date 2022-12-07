//
//  Node.m
//  单链表
//
//  Created by sun on 2019/3/5.
//  Copyright © 2019 sun. All rights reserved.
//

#import "Node.h"

@implementation Node

- (instancetype)init {
    if (self = [super init]) {
        self.name = nil;
        self.next = nil;
    }
    return self;
}

- (instancetype)initWithName:(NSString *)name {
    if (self = [super init]) {
        self.name = name;
        self.next = nil;
    }
    return self;
}

+ (instancetype)node:(NSString *)name {
    return [[self alloc] initWithName:name];
}

@end
