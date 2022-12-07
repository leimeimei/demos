//
//  ViewController.m
//  链表
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
    
    
    NSLog(@"%@",list.toString);
    
    NSLog(@"%@",[list removeAt:2] ? @"success" : @"failed");
    
    NSLog(@"%@",list.toString);
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
