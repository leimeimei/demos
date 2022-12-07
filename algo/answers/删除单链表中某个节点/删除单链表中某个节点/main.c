//
//  main.c
//  删除单链表中某个节点
//
//  Created by sun on 2018/2/8.
//  Copyright © 2018年 sun. All rights reserved.
//

#include <stdio.h>
#include <stdlib.h>

typedef struct Node{
    int data;
    struct Node *next;
}Node;

Node* init(int a[], int n) {
    Node *head = NULL;
    Node *p = NULL;
    for (int i = 0; i < n; i++) {
        Node *nd = (Node *)malloc(sizeof(Node));
        nd->data = a[i];
        if (i == 0) {
            head = p = nd;
            continue;
        }
        p->next = nd;
        p = nd;
    }
    return head;
}
int removeNode(Node *c) {
    if (c == NULL || c->next == NULL) {
        return 0;
    }
    Node *q = c -> next;
    c->data = q->data;
    c->next = q->next;
    free(q);
    return 1;
}
void print(Node *head) {
    while (head) {
        printf("%d",head->data);
        head = head->next;
    }
    printf("\n");
    printf("\n");
}
int main(int argc, const char * argv[]) {
   
    int n = 10;
    int a[] = {9,2,1,3,5,6,2,6,3,1};
    Node *head = init(a, n);
    int cc = 3;
    Node *c = head;
    for (int i = 1; i < cc; ++i) {
        c = c->next;
    }
    print(head);
    if (removeNode(c)) {
        print(head);
    } else {
        printf("failed");
    }
    return 0;
}
