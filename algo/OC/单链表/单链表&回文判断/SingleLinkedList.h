//
//  SingleLinkedList.h
//  单链表
//
//  Created by sun on 2019/3/5.
//  Copyright © 2019 sun. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Node;

NS_ASSUME_NONNULL_BEGIN

@interface SingleLinkedList : NSObject

@property (nonatomic, strong) Node *head;

- (Node *)find:(NSString *)name;

- (NSInteger)indexOf:(NSString *)name;

- (void)append:(NSString *)name;

- (BOOL)insert:(NSString *)name postion:(NSInteger)postion;

- (BOOL)remove:(NSString *)name;

- (BOOL)removeLast;

- (BOOL)removeAt:(NSInteger)postion;

- (BOOL)isEmpty;

- (NSInteger)size;

- (NSString *)toString;

@end

NS_ASSUME_NONNULL_END
