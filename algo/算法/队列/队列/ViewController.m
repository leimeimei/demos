//
//  ViewController.m
//  队列
//
//  Created by sun on 2018/4/3.
//  Copyright © 2018年 sun. All rights reserved.
//

#import "ViewController.h"
#import "Queue.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*
        使用队列解决击鼓传花游戏，每次接到花的出局，求最后留下的一个是第几个
     */
    
    NSMutableArray *peopleArr = [NSMutableArray array];
    Queue *queue = [[Queue alloc] init];
    
    //假设10个人参加游戏
    NSInteger peopleCount = 10;
    //假设数到17的人被淘汰
    NSInteger outNum = 17;
    
    for (NSInteger i = 0; i < peopleCount; i++) {
        NSString *str = [NSString stringWithFormat:@"people%ld",i+1];
        [peopleArr addObject:str];
        [queue append:str];
    }
    
    while (queue.size > 1) {
        //将前num-1个人从队列头部移动到队列尾部
        for (NSInteger i = 0; i < outNum; i++) {
            [queue append:[queue shift]];
        }
        //第outNum个人移除队列
        [queue shift];
    }
    //循环结束后队列中只剩下一个人
    NSLog(@"%ld",[peopleArr indexOfObject:queue.front]+1);
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
