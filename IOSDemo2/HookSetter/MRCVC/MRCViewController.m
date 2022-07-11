//
//  MRCViewController.m
//  IOSDemo2
//
//  Created by xpyue on 2022/1/4.
//

#import "MRCViewController.h"
#import "QMObj.h"
#import "QMCrashSnifferSDKWrapper.h"
//#import <ScreenShieldView/ScreenShieldView-Swift.h>
#import "IOSDemo2-Swift.h"
#import "RyukieSwifty-Swift.h"

@interface MRCViewController ()
@property (nonatomic, assign)  QMObj *obj;
@end

@implementation MRCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    Test2 *ste = [[Test2 alloc] init];
//    ScreenShieldView *view = [[ScreenShieldView alloc] init];
//    view.frame = self.view.bounds;
//
//    self.view.backgroundColor  = UIColor.cyanColor;
//    Class cls = NSClassFromString(@"_UITextFieldCanvasView");
//    NSLog(@"????:%@", cls);
//    UIView *v1 = [[UIView alloc] initWithFrame:CGRectMake(44, 44, 111, 111)];
//    v1.backgroundColor = UIColor.redColor;
//    [self.view addSubview:v1];
//
//    UIView *v2 = [[UIView alloc] initWithFrame:CGRectMake(44, 44, 331, 331)];
//    v2.backgroundColor = UIColor.greenColor;
//
//    UITextField *fild = [[UITextField alloc] initWithFrame:self.view.bounds];
//    fild.secureTextEntry = YES;
//    [fild.subviews.firstObject addSubview:v2];
//    [self.view addSubview:fild];
    
//    NSArray<__kindof UIView *> * arr = [fild subviews];
//    NSLog(@"?????%@",arr);
//    [view addSubview:v2];
//    [self.view addSubview:view];
    
    UITextField *field = [[UITextField alloc] initWithFrame:CGRectMake(0, 200, UIScreen.mainScreen.bounds.size.width, 200)];
    field.backgroundColor = UIColor.redColor;
    field.secureTextEntry = YES;
    [self.view addSubview:field];
    
    UIView *blueView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    blueView.backgroundColor = UIColor.blueColor;
    field.subviews.firstObject.backgroundColor = UIColor.yellowColor;
    [field.subviews.firstObject addSubview:blueView];
    
//    Class textFieldCanvasViewClass = NSClassFromString(@"_UITextFieldCanvasView");
//    id textFieldCanvasView = [[textFieldCanvasViewClass alloc] init];
//    if ([textFieldCanvasView isKindOfClass:UIView.class])
//    {
//        [(UIView *)textFieldCanvasView setFrame:CGRectMake(0, 200, 300, 100)];
//        [(UIView *)textFieldCanvasView setBackgroundColor:UIColor.redColor];
//        [self.view addSubview:textFieldCanvasView];
//    }
//    NSLog(@"????");
}

- (UIView *)makeSecureViewWithNeedSecureEnabled:(BOOL)enabled
{
    UITextField *field = [[UITextField alloc] initWithFrame:self.view.bounds];
    field.secureTextEntry = enabled;
    UIView *secureView = field.subviews.firstObject;
    if (secureView == nil)
    {
        // 兜底一个普通的view
        secureView = [[UIView alloc] initWithFrame:self.view.bounds];
    }
    secureView.userInteractionEnabled = YES;
    return secureView;
}


- (void)getImage {

    
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.view.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageView *imageview = [[UIImageView alloc] initWithImage:image];
    imageview.frame = CGRectMake(90, 190, 300, 300);
    imageview.backgroundColor = UIColor.redColor;
    [self.view addSubview:imageview];
    self.view.backgroundColor = UIColor.whiteColor;
}

+ (UIImage *)viewSnapshot:(UIView *)view withInRect:(CGRect)rect
{
 
    UIGraphicsBeginImageContext(view.bounds.size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGImageRef imageRef = CGImageCreateWithImageInRect(image.CGImage,rect);
    image = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return image;
}

-(UIImage *)captureImageFromViewLow:(UIView *)orgView {
    //获取指定View的图片
    UIGraphicsBeginImageContextWithOptions(orgView.bounds.size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [orgView.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end
