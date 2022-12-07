//
//  main.c
//  二分查找
//
//  Created by sun on 2018/5/21.
//  Copyright © 2018年 sun. All rights reserved.
//

#include <stdio.h>

#define MIN(x, y) (x < y?x:y)
//针对有序数组，查找某个值下标
int binarySearch(int a[], int length, int value) {
    int start = 0;
    int end = length - 1;
    int mid = (start + end) / 2;
    
    while (a[mid] != value && start < end) {
        if (a[mid] > value) {
            end = mid - 1;
        } else if (a[mid] < value) {
            start = mid + 1;
        }
        mid = (start + end) / 2;
    }
    if (a[mid] == value) {
        return mid;
    } else {
        return -1;
    }
}

//rotated sorted array,查找某个值，找不到返回-1
//旋转的有序数组，如{4，5，6，7，1，2，3}
int search(int a[], int length, int target) {
    int start = 0;
    int end = length;
    while (start != end) {
        const int mid = start + (end - start) / 2;
        if (a[mid] == target) {
            return mid;
        } else if (a[start] <= a[mid]) {
            if (a[start] <= target && target < a[mid]) {
                end = mid;
            } else {
                start = mid + 1;
            }
        } else {
            if (a[mid] < target && target <= a[end - 1]) {
                start = mid + 1;
            } else {
                end = mid;
            }
        }
    }
    return -1;
}
//旋转的有序数组，如{4,5,6,7,0,1,2},求最小值
int findMin(int array[], int length) {
    if (length == 0) {
        return 0;
    } else if (length == 1) {
        return array[0];
    } else if (length == 2) {
        return MIN(array[0], array[1]);
    }
    int start = 0;
    int end = length - 1;
    while (start < end-1) {
        if (array[start] < array[end]) {
            return array[start];
        }
        int mid = start + (end - start) / 2;
        if (array[mid] > array[start]) {
            start = mid;
        } else if (array[mid] < array[start]) {
            end = mid;
        }
    }
    return MIN(array[start],array[end]);
}


//旋转的有序数组,有重复项，如{2，2，2，1},求最小值
int findMin1(int array[], int length) {
    if (length == 0) {
        return 0;
    } else if (length == 1) {
        return array[0];
    } else if (length == 2) {
        return MIN(array[0], array[1]);
    }
    int start = 0;
    int end = length - 1;
    while (start < end-1) {
        if (array[start] < array[end]) {
            return array[start];
        }
        int mid = start + (end - start) / 2;
        if (array[mid] > array[start]) {
            start = mid;
        } else if (array[mid] < array[start]) {
            end = mid;
        } else {
            start++;
        }
    }
    return MIN(array[start],array[end]);
}

int main(int argc, const char * argv[]) {
    
    int a[] = {1 , 3 , 4 ,7 ,8 , 12 ,45 ,67 ,97 ,123 ,456 ,675 ,1111 , 4534 , 4563};
    int length = sizeof(a) / sizeof(a[0]);
    int result = binarySearch(a, length, 45);
    printf("%d\n",result);
    
    int b[] = {10,13,25,46,57,79,2,4,6,8,};
    int len = sizeof(b) / sizeof(b[0]);
    int ret = search(b, len, 2);
    printf("%d\n",ret);
    
    int c[] = {4,5,6,7,0,1,2};
    int len1 = sizeof(c) / sizeof(c[0]);
    int ret1 = findMin(c, len1);
    printf("%d\n",ret1);
    
    int d[] = {2,2,2,1};
    int len2 = sizeof(d) / sizeof(d[0]);
    int ret2 = findMin1(d, len2);
    printf("%d\n",ret2);
    
    return 0;
}
