//
//  main.c
//  插入排序
//
//  Created by sun on 2018/12/20.
//  Copyright © 2018 sun. All rights reserved.
//

#include <stdio.h>

void sort_bubble(int a[], int len) {
    if (len <= 1) return;
    
    for (int i = 0; i < len; ++i) {
        int flag = 0;
        for (int j = 0; j < len - 1 - i; ++j) {
            if (a[j] > a[j+1]) {
                int temp = a[j+1];
                a[j+1] = a[j];
                a[j] = temp;
                flag = 1;
            }
        }
        if (flag == 0) break;
    }
}

void sort_insert(int a[], int len) {
    if (len <= 1) return;
    
    for (int i = 1; i < len; ++i) {
        int value = a[i];
        int j = i - 1;
        for (; j >= 0; --j) {
            if (a[j] > value) {
                a[j + 1] = a[j];
            } else {
                break;
            }
        }
        a[j+1] = value;
    }
}
void swap(int *a, int *b) {
    int tmp = *a;
    *a = *b;
    *b = tmp;
}
int partition(int *a, int left, int right) {
    int i, j;
    i = j = left;
    for (; j < right; j++) {
        if (a[j] < a[right]) {
            if (i != j) {
                swap(a + i, a + j);
            }
            i++;
        }
    }
    swap(a + i, a + right);
    return i;
}
void sort_quick(int *a, int left, int right) {
    if (left >= right) return;
    
    int q = partition(a, left, right);
    sort_quick(a, left, q - 1);
    sort_quick(a,q + 1, right);
    
}

int main(int argc, const char * argv[]) {
    
    int a[] = {2,5,8,1,3,6,9};
    
//    sort_insert(a, 7);
    
//    sort_bubble(a, 7);
    
    sort_quick(a, 0, 6);
    
    for (int i = 0; i < 7; ++i) {
        printf("%d\n",a[i]);
    }
    
    return 0;
}
