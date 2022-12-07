//
//  OneView.m
//  WW
//
//  Created by sun on 2022/8/26.
//

#import "OneView.h"

@implementation OneView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    self.wantsLayer = YES;
    self.layer.backgroundColor = [NSColor cyanColor].CGColor;
}

@end
