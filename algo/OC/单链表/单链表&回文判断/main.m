//
//  main.m
//  单链表
//
//  Created by sun on 2019/3/5.
//  Copyright © 2019 sun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Node.h"
#import "SingleLinkedList.h"

BOOL checkPalindromelist(SingleLinkedList *list) {
    // 使用快慢指针找中间点
    Node *slow, *fast, *midNode;
    slow = list.head;
    fast = list.head;
    while (fast.next != nil) {
        slow = slow.next;
        fast = fast.next;
        if (fast.next != nil) {
            fast = fast.next;
            midNode = slow.next;
        } else {
            midNode = nil;
        }
    }
    
    //从中间向后逆转链表（区分奇偶）
    Node *mid = slow;
    Node *elem, *prev, *save;
    if (midNode == nil) {// odd
        elem = mid;
        prev = mid.next;
    } else {
        elem = midNode;
        prev = midNode.next;
        midNode.next = nil;
    }
    save = prev.next;
    mid.next = nil;
    while (save != nil) {
        prev.next = elem;
        elem = prev;
        prev = save;
        save = save.next;
    }
    prev.next = elem;
    
    Node *end = prev;
    Node *front = list.head.next;
    
    // 从头尾同时遍历比较，检测是否为回文
    BOOL palindrome = true;
    while (front != end) {
        if (![front.name isEqualToString:end.name]) {
            palindrome = NO;
            break;
        }
        front = front.next;
        end = end.next;
    }
    
    return palindrome;
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        SingleLinkedList *list = [[SingleLinkedList alloc] init];
        
        NSArray *arr = @[@"1",@"2",@"3",@"3",@"2",@"1"];
        for (NSString *str in arr) {
            [list append:str];
        }
        NSLog(@"%@",[list toString]);
        
        checkPalindromelist(list) ? NSLog(@"yes") : NSLog(@"no");
        
        arr = @[@"1",@"2",@"3",@"3",@"2",@"1",@"2"];
        
        checkPalindromelist(list) ? NSLog(@"yes") : NSLog(@"no");
        
    }
    return 0;
}
