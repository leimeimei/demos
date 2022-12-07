//
//  Node.h
//  双向链表
//
//  Created by sun on 2018/4/3.
//  Copyright © 2018年 sun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Node : NSObject

//双向链表
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) Node *pre;
@property (nonatomic, strong) Node *next;

+ (instancetype)node:(NSString *)name;

- (void)append:(NSString *)name;

- (BOOL)insert:(NSString *)name postion:(NSInteger)postion;

- (BOOL)remove:(NSString *)name;

- (BOOL)removeAt:(NSInteger)postion;

- (NSInteger)indexOf:(NSString *)name;

- (BOOL)isEmpty;

- (NSInteger)size;

- (NSString *)forwardString;

- (NSString *)reverseString;

- (NSString *)toString;

@end
