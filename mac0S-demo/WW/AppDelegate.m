//
//  AppDelegate.m
//  WW
//
//  Created by sun on 2022/8/26.
//

#import "AppDelegate.h"
#import "OneView.h"
#import "OneViewController.h"
#import "Test.h"

@interface AppDelegate ()

@property (nonatomic, strong) NSWindow *window;
@property (nonatomic, strong) OneViewController *oneVC;
@property (nonatomic, strong) Test *t;
@property (weak) IBOutlet NSMenu *dockMenu;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    [self.window center];
    [self.window orderFront:nil];
    
//    OneView *view = [[OneView alloc] initWithFrame:CGRectMake(0, 30, 200, 200)];
//    [self.window.contentView addSubview:view];
    
    self.window.contentViewController = self.t;
    self.window.title = @"demo";
    
}
- (NSMenu *)applicationDockMenu:(NSApplication *)sender {
    return self.dockMenu;
}
- (IBAction)openNew:(id)sender {
    NSString *path = [[NSBundle mainBundle] executablePath];
    NSTask *task = [[NSTask alloc] init];
    task.launchPath = path;
    [task launch];
}
- (IBAction)clickDockMenu1:(id)sender {
    NSLog(@"clickDockMenu1");
}
- (IBAction)clidkDockMenu2:(id)sender {
    NSLog(@"clickDockMenu2");
}

- (Test *)t {
    if (!_t) {
        _t = [[Test alloc] initWithNibName:@"Test" bundle:nil];
    }
    return _t;
}


- (OneViewController *)oneVC {
    if (!_oneVC) {
        _oneVC = [[OneViewController alloc] init];
        NSView *view = [[NSView alloc] initWithFrame:CGRectMake(0, 0, 200, 100)];
        view.wantsLayer = YES;
        view.layer.backgroundColor = [NSColor yellowColor].CGColor;
        _oneVC.view = view;
    }
    return _oneVC;
}


- (NSWindow *)window {
    if (!_window) {
        NSUInteger style = NSWindowStyleMaskTitled | NSWindowStyleMaskClosable | NSWindowStyleMaskMiniaturizable;
        _window = [[NSWindow alloc] initWithContentRect:CGRectMake(0, 0, 200, 300) styleMask:style backing:NSBackingStoreBuffered defer:YES];
    }
    return _window;
}


@end
