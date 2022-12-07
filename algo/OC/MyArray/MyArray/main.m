//
//  main.m
//  MyArray
//
//  Created by sun on 2019/3/5.
//  Copyright © 2019 sun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyArray.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        MyArray *arr = [[MyArray alloc] initWithCapacity:3];
        [arr addObject:@10];
        [arr addObject:@20];
        [arr addObject:@30];
        NSLog(@"%lu",arr.count);
        [arr removeObjectAtIndex:0];
        [arr print];
        NSLog(@"%lu",arr.count);
    }
    return 0;
}
