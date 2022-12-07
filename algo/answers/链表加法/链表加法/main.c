//
//  main.c
//  链表加法
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
    for (int i = 0; i < n ; i++) {
        Node *nd = (Node *)malloc(sizeof(Node));
        nd->data = a[i];
        if (i == 0) {
            head = p = nd;
            continue;
        }
        p->next = nd;
        p = p -> next;
    }
    return head;
}
Node* addLink(Node *p, Node *q) {
    if (p == NULL) return q;
    if (q == NULL) return p;
    Node *res;
    Node *pre = NULL;
    
    int c = 0;
    while (p && q) {
        int t = p->data + q->data + c;
        Node *r = (Node *)malloc(sizeof(Node));
        r->data = t % 10;
        if (pre) {
            pre->next = r;
            pre = r;
        } else {
            pre = res = r;
        }
        c = t / 10;
        p = p->next;
        q = q->next;
    }
    while (p) {
        int t = p->data + c;
        Node *r = (Node *)malloc(sizeof(Node));
        r->data = t % 10;
        pre->next = r;
        pre = r;
        c = t/10;
        p = p->next;
    }
    while (q) {
        int t = q->data + c;
        Node *r = (Node *)malloc(sizeof(Node));
        r->data = t%10;
        pre->next = r;
        pre = r;
        c = t/10;
        q = q->next;
    }
    if (c>0) {
        Node *r = (Node *)malloc(sizeof(Node));
        r->data = c;
        pre->next = r;
    }
    return res;
}
void print(Node *head) {
    while (head) {
        printf("%d\n",head->data);
        head = head->next;
    }
    printf("\n");
    printf("\n");
}

int main(int argc, const char * argv[]) {
    
    int n = 4;
    int a[] = {1,2,9,3};
    int m = 3;
    int b[] = {9,9,2};
    
    Node *p = init(a, n);
    Node *q = init(b, m);
    
    
    if (p) {
        print(p);
    }
    if (q) {
        print(q);
    }
    Node *res = addLink(p, q);
    if (res) {
        print(res);
    }
    
    return 0;
}
