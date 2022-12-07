//
//  Node.m
//  双向链表
//
//  Created by sun on 2018/4/3.
//  Copyright © 2018年 sun. All rights reserved.
//

#import "Node.h"
@interface Node()

@property (nonatomic, assign) NSInteger length;
@property (nonatomic, strong) Node *head;
@property (nonatomic, strong) Node *tail;

@end

@implementation Node

- (instancetype)init {
    if (self = [super init]) {
        _length = 0;
        _head = nil;
        _tail = nil;
    }
    return self;
}

- (instancetype)initWithName:(NSString *)name {
    if (self = [super init]) {
        self.name = name;
        self.next = nil;
        self.pre = nil;
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
        self.tail = newNode;
    } else {
        self.tail.next = newNode;
        newNode.pre = self.tail;
        self.tail = newNode;
    }
    self.length++;
}

- (BOOL)insert:(NSString *)name postion:(NSInteger)postion {
    if (postion < 0 || postion > self.length) {
        return NO;
    }
    Node *newNode = [Node node:name];
    
    if (postion == 0) {
        if (self.head == nil) {
            self.head = newNode;
            self.tail = newNode;
        } else {
            self.head.pre = newNode;
            newNode.next = self.head;
            self.head = newNode;
        }
    } else if (postion == self.length) {
        self.tail.next = newNode;
        newNode.pre = self.tail;
        self.tail = newNode;
    } else {
        //此处为正向遍历，如果position>length/2,可以从后往前遍历，提高性能，有待补充
        NSInteger index = 0;
        Node *current = self.head;
        Node *preNode = nil;
        
        while (index++ < postion) {
            preNode = current;
            current = current.next;
        }
        newNode.next = current;
        newNode.pre = preNode;
        current.pre = newNode;
        preNode.next = newNode;
    }
    self.length++;
    return YES;
}

- (BOOL)remove:(NSString *)name {
    return [self removeAt:[self indexOf:name]];
}

- (BOOL)removeAt:(NSInteger)postion {
    if (postion < 0 || postion >= self.length) {
        return NO;
    }
    Node *current = self.head;
    if (postion == 0) {
        if (self.length == 1) {
            self.head = nil;
            self.tail = nil;
        } else {
            self.head = self.head.next;
            self.head.pre = nil;
        }
    } else if (postion == self.length - 1) {
        current = self.tail;
        self.tail = self.tail.pre;
        self.tail.next = nil;
    } else {
        NSInteger index = 0;
        Node *preNode = nil;
        while (index++ < postion) {
            preNode = current;
            current = current.next;
        }
        preNode.next = current.next;
        current.next.pre = preNode;
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

- (NSString *)forwardString {
    Node *current = self.head;
    NSString *result = [NSString string];
    while (current) {
        result = [result stringByAppendingFormat:@"%@,",current.name];
        current = current.next;
    }
    return result;
}

- (NSString *)reverseString {
    Node *current = self.tail;
    NSString *result = [NSString string];
    while (current) {
        result = [result stringByAppendingFormat:@"%@,",current.name];
        current = current.pre;
    }
    return result;
}

- (NSString *)toString {
    return [self forwardString];
}

@end
