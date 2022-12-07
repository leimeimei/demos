//
//  Node.m
//  链表
//
//  Created by sun on 2018/4/3.
//  Copyright © 2018年 sun. All rights reserved.
//

#import "Node.h"

@interface Node()
@property (nonatomic, strong) Node *head;
@property (nonatomic, assign) NSInteger length;
@end

@implementation Node

- (instancetype)init {
    if (self = [super init]) {
        self.length = 0;
        self.head = nil;
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

- (void)append:(NSString *)name {
    Node *newNode = [Node node:name];
    if (self.head == nil) {
        self.head = newNode;
    } else {
        Node *node = self.head;
        while (node.next) {
            node = node.next;
        }
        node.next = newNode;
    }
    self.length++;
}

- (BOOL)insert:(NSString *)name postion:(NSInteger)postion {
    if (postion < 0 || postion > self.length) {
        return NO;
    }
    Node *newNode = [Node node:name];
    Node *current = self.head;
    Node *preNode = nil;
    NSInteger index = 0;
    if (postion == 0) {
        newNode.next = current;
        self.head = newNode;
    } else {
        while (index++ < postion) {
            preNode = current;
            current = current.next;
        }
        newNode.next = current;
        preNode.next = newNode;
    }
    self.length++;
    return YES;
}

- (BOOL)remove:(NSString *)name {
    NSInteger index = [self indexOf:name];
    return [self removeAt:index];
}

- (BOOL)removeAt:(NSInteger)postion {
    if (postion < 0 || postion >= self.length) {
        return NO;
    }
    Node *current = self.head;
    Node *preNode = nil;
    NSInteger index = 0;
    if (postion == 0) {
        self.head = current.next;
    } else {
        while (index++ < postion) {
            preNode = current;
            current = current.next;
        }
        preNode.next = current.next;
    }
    self.length--;
    return YES;
}

- (NSInteger)indexOf:(NSString *)name {
    Node *current = self.head;
    NSInteger index = 0;
    while (current) {
        if ([current.name isEqualToString:name]) {
            return index;
        }
        index++;
        current = current.next;
    }
    return -1;
}

- (BOOL)isEmpty {
    return self.length == 0;
}

- (NSInteger)size {
    return self.length;
}

- (NSString *)toString {
    Node *current = self.head;
    NSString *result = [NSString string];
    while (current) {
        result = [result stringByAppendingFormat:@"%@,",current.name];
        current = current.next;
    }
    return result;
}

@end
