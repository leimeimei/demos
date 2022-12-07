//
//  SingleLinkedList.m
//  单链表
//
//  Created by sun on 2019/3/5.
//  Copyright © 2019 sun. All rights reserved.
//

#import "SingleLinkedList.h"
#import "Node.h"

@interface SingleLinkedList()

@property (nonatomic, assign) NSInteger count;

@end

@implementation SingleLinkedList

- (instancetype)init {
    if (self = [super init]) {
        self.head = [[Node alloc] init];// 哨兵节点，空节点
        self.head.next = nil;
        self.head.name = nil;
        self.count = 0;
    }
    return self;
}

- (Node *)find:(NSString *)name {
    Node *current = self.head;
    NSInteger index = 0;
    while (current) {
        if ([current.name isEqualToString:name]) {
            return current;
        }
        index++;
        current = current.next;
    }
    return nil;
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
    self.count++;
}

- (BOOL)insert:(NSString *)name postion:(NSInteger)postion {
    if (postion < 0 || postion > self.count) {
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
    self.count++;
    return YES;
}

- (BOOL)removeAt:(NSInteger)postion {
    if (postion < 0 || postion > self.count) {
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
        preNode.next = current;
    }
    self.count--;
    return YES;
}

- (BOOL)remove:(NSString *)name {
    NSInteger index = [self indexOf:name];
    return [self removeAt:index];
}

- (BOOL)removeLast {
    if (self.count == 0) {
        return NO;
    }
    Node *current = self.head;
    Node *preNode = nil;
    while (current.next) {
        preNode = current;
        current = current.next;
    }
    preNode.next = nil;
    self.count--;
    return YES;
}

- (BOOL)isEmpty {
    return self.count == 0;
}

- (NSInteger)size {
    return self.count;
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
