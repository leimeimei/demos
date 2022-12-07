//
//  Node.h
//  单链表
//
//  Created by sun on 2019/3/5.
//  Copyright © 2019 sun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Node : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) Node *next;

+ (instancetype)node:(NSString *)name;

@end

