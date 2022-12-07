//
//  main.m
//  判断字符串是否有重复
//
//  Created by sun on 2018/2/8.
//  Copyright © 2018年 sun. All rights reserved.
//

#import <Foundation/Foundation.h>

BOOL isUnique(NSString *str) {
    int check = 0;
    NSUInteger len = str.length;
    for (int i = 0; i < len; i++) {
        NSUInteger v = (NSUInteger)([str characterAtIndex:i] - 'a');
        if (check & (1 << v)) {
            return NO;
        }
        check |= (1 << v);
    }
    return YES;
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSString *str = @"abcda";
        isUnique(str) ? NSLog(@"yes") : NSLog(@"no");
    }
    return 0;
}


