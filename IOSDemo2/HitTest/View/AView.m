//
//  AView.m
//  IOSDemo2
//
//  Created by xpyue on 2022/5/2.
//

#import "AView.h"

@interface AView ()

@end

@implementation AView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.text = @"A";
        self.textAlignment = NSTextAlignmentCenter;
        self.backgroundColor = UIColor.redColor;
        self.userInteractionEnabled = YES;
    }
    return self;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"AView 响应");
    [super touchesBegan:touches withEvent:event];
}
@end
