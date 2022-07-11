//
//  CView.m
//  IOSDemo2
//
//  Created by xpyue on 2022/5/2.
//

#import "CView.h"

@implementation CView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.text = @"C";
        self.textAlignment = NSTextAlignmentCenter;
        self.backgroundColor = UIColor.yellowColor;
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"CView 响应");
    [super touchesBegan:touches withEvent:event];
}

@end
