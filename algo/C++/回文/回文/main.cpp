//
//  main.cpp
//  回文
//
//  Created by sun on 2018/12/18.
//  Copyright © 2018 sun. All rights reserved.
//

#include <cstdio>
#include "LinkedList.hpp"

bool CheckPalindromeList(LinkedList *list) {
    // 使用快慢指针找链表中点
    ListNode *slow, *fast, *mid2;
    slow = list -> head;
    fast = list -> head;
    while (fast -> next != nullptr) {
        slow = slow -> next;
        fast = fast -> next;
        if (fast -> next != nullptr) {
            fast = fast -> next;
            mid2 = slow -> next;
        } else {
            mid2 = nullptr;
        }
    }
    
    // 从中点向后逆转链表（区分奇偶情况）
    ListNode *mid = slow;
    ListNode *elem, *prev, *save;
    if (mid2 == nullptr) {  // odd
        elem = mid;
        prev = mid -> next;
    } else {  // even
        elem = mid2;
        prev = mid2 -> next;
        mid2 -> next = nullptr;
    }
    save = prev -> next;
    mid -> next = nullptr;
    while (save != nullptr) {
        prev -> next = elem;
        elem = prev;
        prev = save;
        save = save -> next;
    }
    prev -> next = elem;
    
    ListNode *end = prev;
    ListNode *front = list -> head -> next;
    
    // 从头尾同时遍历比较，检测链表是否为回文
    bool palindrome = true;
    while (front != end) {
        // printf("%d, %d\n", front -> val, end -> val);
        if (front -> val != end -> val) {
            palindrome = false;
            break;
        }
        front = front -> next;
        end = end -> next;
    }
    
    palindrome ? printf("The list is palindrome~\n") : printf("The list is not palindrome!\n");
    
    return palindrome;
}

int main(int argc, const char * argv[]) {
    
    int init[] = {1, 2, 3, 2, 1};
    LinkedList *list = new LinkedList(5);
    for (int i = 0; i < 5; i++) {
        list -> InsertElemAtBack(init[i]);
    }
    list -> PrintList();
    
    CheckPalindromeList(list);  // true
    
    list -> InsertElemAtFront(5);
    CheckPalindromeList(list);  // false
    
    return 0;
}
