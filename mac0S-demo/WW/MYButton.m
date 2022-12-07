//
//  MYButton.m
//  WW
//
//  Created by sun on 2022/8/26.
//

#import "MYButton.h"


@interface NaviButtonCell : NSButtonCell

@end

@implementation NaviButtonCell
 
- (NSRect)imageRectForBounds:(NSRect)rect {
    return NSMakeRect(20, 7, 30, 30);
}
- (NSRect)titleRectForBounds:(NSRect)rect {
    return NSMakeRect(50, 0, rect.size.width - 50, rect.size.height);
}

@end


@implementation MYButton

+ (Class)cellClass {
    return [NaviButtonCell class];
}

- (void)drawRect:(NSRect)dirtyRect {

    
    [super drawRect:dirtyRect];
}



- (NSSize)intrinsicContentSize {
    NSSize size = [super intrinsicContentSize];
    size.width += self.margin;
    return size;
}

@end
