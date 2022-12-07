//
//  main.c
//  链表操作C
//
//  Created by sun on 2018/12/18.
//  Copyright © 2018 sun. All rights reserved.
/**
* 1) 单链表反转
* 2) 链表中环的检测
* 3) 两个有序的链表合并
* 4) 删除链表倒数第 n 个结点
* 5) 求链表的中间结点
*/

#include <stdio.h>
#include <stdlib.h>

typedef struct Node{
    int data;
    struct Node *next;
}Node;
/*基本方法*/
void insert(Node **head, int data) {
    Node *newNode = malloc(sizeof(Node));
    newNode -> data = data;
    newNode -> next = *head;
    *head = newNode;
}
void printLinkedNode(Node *node) {
    printf("--- start ---\n");
    while (node) {
        printf("data:%d\n",node -> data);
        node = node -> next;
    }
    printf("--- end ---\n");
}

/*反转单链表*/
void reverse(Node **head) {
    if (*head == NULL) return;
    
    Node *Prev = NULL;
    Node *current = *head;
    while (current) {
        Node *next = current -> next;
        if (!next) {
            // 到达尾节点，将地址存入head
            *head = current;
        }
        current -> next = Prev;
        Prev = current;
        current = next;
        printLinkedNode(*head);
    }
}
void test_reverse() {
    Node *head = NULL;
    insert(&head, 5);
    insert(&head, 4);
    insert(&head, 3);
    insert(&head, 2);
    insert(&head, 1);
    printLinkedNode(head);
    reverse(&head);
    printLinkedNode(head);
}

/** 检测单链表是否有环 */
int checkCircle(Node **head) {
    if (*head == NULL) return 0;
    
    Node *slow = *head, *fast = *head;
    
    while (fast != NULL && fast -> next != NULL) {
        fast = fast -> next -> next;
        slow = slow -> next;
        if (slow == fast) return 1;
    }
    return 0;
}
void test_circle() {
    Node *head = NULL;
    insert(&head, 5);
    insert(&head, 4);
    insert(&head, 3);
    insert(&head, 2);
    insert(&head, 1);
    
    int result1 = checkCircle(&head);
    printf("has circle:%d\n",result1);
    
    Node *current = malloc(sizeof(Node));
    current -> data = 0;
    Node *h = current;
    for (int i = 0; i < 5; ++i) {
        Node *node = malloc(sizeof(Node));
        node -> data = i;
        current ->next = node;
    }
    current -> next = h;
    int result2 = checkCircle(&h);
    printf("has circle:%d\n",result2);
}

/** 有序链表合并 */

// 将 src 的头结点，添加到 dest 的头部。
void moveNode(Node **dest, Node **src) {
    if (*src == NULL) return;
    
    Node *newNode = *src;
    *src = newNode -> next;
    newNode -> next = *dest;
    *dest = newNode;
}

Node *combine(Node *la, Node *lb) {
    // 辅助结点，next 指针持有合并后的有序链表
    Node dummy;
    Node *tail = &dummy;
    
    while (1) {
        if (!la) {
            tail -> next = lb;
            break;
        } else if (!lb) {
            tail -> next = la;
            break;
        }
        // 将头结点较小的优先添加到 tail
        if (la -> data <= lb ->data) {
            moveNode(&(tail -> next), &la);
        } else {
            moveNode(&(tail -> next), &lb);
        }
        tail = tail -> next;
    }
    return dummy.next;
}

void test_combine() {
    Node* a = NULL;
    insert(&a, 10);
    insert(&a, 5);
    insert(&a, 0);
    
    Node* b = NULL;
    insert(&b, 8);
    insert(&b, 6);
    insert(&b, 3);
    
    Node *result = combine(a, b);
    printLinkedNode(result);
    
    Node *result2 = combine(a, NULL);
    printLinkedNode(result2);
}

/** 删除倒数第 K 个结点 */
void deleteK(Node **head, int k) {
    if (*head == NULL || k == 0) return;
    
    // 快指针向前移动 k-1
    Node *fast = *head;
    int i = 1;
    while (i < k && fast != NULL) {
        fast = fast -> next;
        ++i;
    }
    // 如果快指针为空，说明结点个数小于 k
    if (fast == NULL) return;
    
    Node *slow = *head;
    Node *prev = NULL;
    while (fast->next != NULL) {
        fast = fast -> next;
        prev = slow;
        slow = slow -> next;
    }
    if (!prev) {
        (*head) = (*head) -> next;
    } else {
        prev ->next = slow ->next;
    }
    free(slow);
}

void test_deleteK() {
    Node* head = NULL;
    insert(&head, 1);
    insert(&head, 2);
    insert(&head, 3);
    insert(&head, 4);
    insert(&head, 5);
    
    deleteK(&head, 5);
    printLinkedNode(head);
    
    deleteK(&head, 2);
    printLinkedNode(head);
}

/** 求中间结点  */
Node * findMiddle(Node *head) {
    if (!head) return NULL;
    
    Node *slow = head;
    Node *fast = head;
    
    // 1. 慢指针走一步，快指针两步
    while (fast -> next != NULL && fast -> next -> next != NULL) {
        slow = slow -> next;
        fast = fast -> next -> next;
    }
    return slow;
}
void test_fineMiddle() {
    Node* head = NULL;
    insert(&head, 1);
    insert(&head, 2);
    insert(&head, 3);
    insert(&head, 4);
    insert(&head, 5);
    
    Node *mid = findMiddle(head);
    printf("%d\n", mid->data);
    printLinkedNode(head);
}

int main(int argc, const char * argv[]) {
    
//    test_reverse();
    
//    test_circle();
//
    test_combine();
//
//    test_deleteK();
//
//    test_fineMiddle();
    
    return 0;
}
