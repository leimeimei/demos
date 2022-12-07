//
//  main.c
//  矩阵逆时针旋转
//
//  Created by sun on 2018/2/8.
//  Copyright © 2018年 sun. All rights reserved.
//

#include <stdio.h>

void swap(int *a, int *b) {
    int t = *a;
    *a = *b;
    *b = t;
}
void transpose(int a[][4], int n) {
    for (int i = 0; i < n; ++i) {
        for (int j = i+1; j<n; ++j) {
            swap(&a[i][j], &a[j][i]);
        }
    }
    for (int i = 0; i<n/2; ++i) {
        for (int j = 0; j < n; ++j) {
            swap(&a[i][j], &a[n-1-i][j]);
        }
    }
}

int main(int argc, const char * argv[]) {
    
    int a[4][4] = {
        {1,2,3,4},
        {5,6,7,8},
        {9,10,11,12},
        {13,14,15,16}
    };
    for (int i = 0; i<4; i++) {
        for (int j = 0; j < 4; j++) {
            printf("%d ",a[i][j]);
        }
        printf("\n");
    }
    transpose(a, 4);
    printf("\n");
    printf("\n");
    for (int i = 0; i<4; i++) {
        for (int j = 0; j < 4; j++) {
            printf("%d ",a[i][j]);
        }
        printf("\n");
    }
    return 0;
}
