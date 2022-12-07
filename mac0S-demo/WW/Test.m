//
//  Test.m
//  WW
//
//  Created by sun on 2022/8/26.
//

#import "Test.h"
#import "MYButton.h"

@interface Test ()
@property (weak) IBOutlet NSButton *button;
@property (strong) IBOutlet NSMenu *buttonMenu;// 点击button出现
@property (strong) IBOutlet NSMenu *rightButtonMenu;// 右键菜单

@end

@implementation Test
- (IBAction)click:(NSButton *)sender {
    // 自定义button
    MYButton *btn = [[MYButton alloc] initWithFrame:CGRectMake(100, 100, 100, 45)];
    btn.wantsLayer = YES;
    btn.title = @"标题";
    btn.image = [NSImage imageNamed:@"123"];
    [btn setTarget:self];
    [btn setAction:@selector(touch:)];
    btn.alternateTitle = @"选中";
    btn.alternateImage = [NSImage imageNamed:@"123"];
    btn.state = 1;
    btn.imagePosition = NSImageLeading;
    btn.imageScaling = NSImageScaleNone;
    btn.bordered = YES;
    btn.transparent = NO;
    
    [self.view addSubview:btn];
    
    
    // 点击按钮弹出菜单
    NSPoint point = sender.frame.origin;
    point.x += 30;
    point.y -= 10;
    [self.buttonMenu popUpMenuPositioningItem:nil atLocation:point inView:self.view];
    
}

- (void)touch:(NSButton *)button {
    NSLog(@"touch");
}
- (IBAction)copy:(id)sender {
    NSLog(@"copy");
}
- (IBAction)paste:(id)sender {
    NSLog(@"paste");
}
- (IBAction)click1:(id)sender {
    NSLog(@"在");
}
- (IBAction)click2:(id)sender {
    NSLog(@"南");
}
- (IBAction)click3:(id)sender {
    NSLog(@"京");
}
- (IBAction)dateChangeAction:(NSDatePicker *)sender {
    NSLog(@"%@",sender.dateValue);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    self.view.wantsLayer = YES;
    self.view.layer.backgroundColor = [NSColor yellowColor].CGColor;
    
    // 设置右键菜单
    self.view.menu = self.rightButtonMenu;
    
    
}

@end
