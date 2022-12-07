//
//  main.c
//  RemoveDuplicatesFromSortedArray
//
//  Created by sun on 2018/5/21.
//  Copyright © 2018年 sun. All rights reserved.
//

#include <stdio.h>
/*
指定了是一个有序数组，所以严格比较相邻两个元素
 使用index记录最后一个不重复的元素，不重复则index后移，重复则不移动，
 */
//时间:O(N)  空间：O(1)
int removeDuplicates(int a[], int length) {
    int index = 0;
    for (int i = 1; i < length; i++) {
        printf("%d--%d\n",a[index],a[i]);
        if (a[index] != a[i]) {
            a[++index] = a[i];
        }
    }
    //需要加上最后一个元素
    return index + 1;
}

//允许重复2次，重复的次数由index决定
//时间:O(N)  空间：O(1)
int removeDuplicates1(int a[], int length) {
    int index = 2;
    for (int i = 2; i < length; i++) {
        printf("%d--%d\n",a[index],a[i]);
        if (a[index - 2] != a[i]) {
            a[index++] = a[i];
        }
    }
    return index;
}


int main(int argc, const char * argv[]) {
    
    int a[] = {1,2,2,2,3,3,3,4,5,6,7,7,8};
    int length = sizeof(a)/sizeof(a[0]);
    int index = removeDuplicates1(a,length);
    printf("%d\n",index);
    
    return 0;
}
