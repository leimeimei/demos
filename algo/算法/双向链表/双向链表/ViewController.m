//
//  ViewController.m
//  双向链表
//
//  Created by sun on 2018/4/3.
//  Copyright © 2018年 sun. All rights reserved.
//

#import "ViewController.h"
#import "Node.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Node *list = [[Node alloc] init];
    
    [list append:@"Mike"];
    [list append:@"Dick"];
    [list append:@"Tony"];
    
        [list insert:@"Joke" postion:0];
    
    NSLog(@"%@",list.toString);
    NSLog(@"%@",list.reverseString);
    
    NSLog(@"%@",[list removeAt:2] ? @"success" : @"failed");
    
    NSLog(@"%@",list.toString);

    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
