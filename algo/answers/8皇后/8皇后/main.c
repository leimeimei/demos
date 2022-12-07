//
//  main.c
//  8皇后
//
//  Created by sun on 2018/2/11.
//  Copyright © 2018年 sun. All rights reserved.
//

#include <stdio.h>

int c[20];
int n = 8;
int cnt = 0;
void print(){
    for (int i = 0; i<n; i++) {
        for (int j = 0; j < n; j++) {
            if (j == c[i]) {
                printf("1 ");
            } else {
                printf("0 ");
            }
        }
        printf("\n");
    }
    printf("\n");
}
void search(int r) {
    if (r == n) {
        print();
        ++cnt;
        return;
    }
    for (int i = 0; i < n; i++) {
        c[r] = i;
        int ok = 1;
        for (int j = 0; j < r; j++) {
            if (c[r] == c[j] || r-j == c[r] - c[j] || r-j == c[j] - c[r]) {
                ok = 0;
                break;
            }
        }
        if (ok) {
            search(r + 1);
        }
    }
}

int main(int argc, const char * argv[]) {
    
    search(0);
    
    printf("%d\n",cnt);
    
    return 0;
}
