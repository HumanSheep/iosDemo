//
//  BView.m
//  IOSDemo2
//
//  Created by xpyue on 2022/5/2.
//

#import "BView.h"

@implementation BView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.text = @"B";
        self.textAlignment = NSTextAlignmentCenter;
        self.backgroundColor = UIColor.greenColor;
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"BView 响应");
//    [super touchesBegan:touches withEvent:event];
}

@end
