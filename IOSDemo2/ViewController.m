//
//  ViewController.m
//  IOSDemo
//
//  Created by xpyue on 2021/3/19.
//

#import "ViewController.h"
#import "ModalViewController.h"
#import "QMObj.h"
#import "LandscapeVC.h"
#include <pthread.h>
#import "MRCViewController.h"
#import <objc/runtime.h>
#import <mach-o/dyld.h>
#include "fishhook.h"
#import "SDWebImage.h"
#import "UIView+WebCache.h"

static NSString *matchCrash = @"SIGSEGV";
@interface ViewController () <UIGestureRecognizerDelegate>
{
    UIView *backGroundView;
    UIView *k;
    NSUInteger _ind;
}
@property (nonatomic, strong) UIButton *btn;
@property (nonatomic, strong) UIView *v1;


// 学习自动布局
@property (nonatomic, strong) UIImageView *q1;
@property (nonatomic, strong) UIButton *q2;
@property (nonatomic, strong) UIView *q3;
@property (nonatomic, strong) UIImageView *i1;
@property (nonatomic, strong) NSMutableString *arr;


@property (nonatomic, strong) UISlider *slider;
@property (nonatomic, strong) UIProgressView *progressView;

// 旋转懂话

@property (nonatomic, strong) UIView *redView;
@property (nonatomic, strong) UIButton *orientationbtn;
@property (nonatomic, assign) BOOL isFull;
@property (nonatomic, strong) LandscapeVC *fullVC;
@property (nonatomic, assign) CGPoint point;
@end

@implementation ViewController

- (void)loadView{
    [super loadView];
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(50, 50, 200, 200)];
    view1.backgroundColor = UIColor.redColor;
    [self.view addSubview:view1];
    view1 = nil;
    self.redView = [[UIView alloc] initWithFrame:CGRectMake(50, 550, 200, 200)];
    self.redView.backgroundColor = UIColor.redColor;
    [self.view addSubview:self.redView];
    self.title = @"demo";
    [self copyFile];
}

- (void)hh
{
    
    
}
//100000000000000000000001000001101101110000010111101001001
//100000000000000000000001000001101101110000010111101001011
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"点击空白");
    //    [self.redView removeFromSuperview];
    self.redView = nil;
    MRCViewController *mrc = [[MRCViewController alloc] init];
    [self.navigationController pushViewController:mrc animated:YES];
    
}
void a()
{
    ab();
    abc();
}
void ab()
{
    
}

void abc()
{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    a();
//
//    [self getImage];
//    NSObject *obj = [[NSObject alloc] init];
//    NSLog(@"isa: %p", *(void **)(__bridge void *)obj);
//    objc_setAssociatedObject(obj, @"key", @"value", OBJC_ASSOCIATION_RETAIN);
//    NSLog(@"isa: %p", *(void **)(__bridge void *)obj);
//
//    Class newClass = objc_allocateClassPair([NSError class], "RuntimeErrorSubclass", 0);
//    class_addMethod(newClass, @selector(report), (IMP)ReportFunction, "v@:");
//    objc_registerClassPair(newClass);
//
//    NSLog(@"%d", sizeof(obj));
//    NSLog(@"%d", sizeof([obj class]));
//    NSLog(@"%d", sizeof([obj superclass]));
//
//    uint32_t i;
//    uint32_t ic = _dyld_image_count();
//
//    printf("Got %d images\n", ic);
//    for (i = 0; i < ic; ++ i) {
//        printf("%d: %p\t%s\t(slide: %p)\n",
//               i,
//               _dyld_get_image_header(i),
//               _dyld_get_image_name(i),
//               _dyld_get_image_vmaddr_slide(i));
//    }
//
//    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(51, 32, 444, 222)];
//    [image sd_setImageWithURL:@"https://largefile-1304019119.cos.ap-chengdu.myqcloud.com/testImage/nyancat-animated%402x.webp"];
//
//    [image sd_internalSetImageWithURL:[NSURL URLWithString:@"https://largefile-1304019119.cos.ap-chengdu.myqcloud.com/testImage/nyancat-animated%402x.webp"] placeholderImage:nil options:0 context:nil setImageBlock:^(UIImage * _Nullable image, NSData * _Nullable imageData, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
//
//    } progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
//
//    } completed:^(UIImage * _Nullable image3, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
//        CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
//
//            int count = CGImageSourceGetCount(source);
//            NSMutableArray *images = [NSMutableArray array];
//            for (int i = 0; i < count; i++)
//            {
//                // 遍历得到每一帧
//                CGImageRef image = CGImageSourceCreateImageAtIndex(source, i, NULL);
//                [images addObject:[UIImage imageWithCGImage:image scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp]];
//                // 注意释放, 可以在这儿加一个 autorelease
//                CGImageRelease(image);
//            }
//            // CGImageSourceRef 也要释放
//            CFRelease(source);
//
//        UIImageView *imageView = image;
//            // 通过 animationImages 设置动画
//            imageView.animationImages = images;
//            // 获取每一帧的处理略复杂, 先按照每一帧 100ms 吧
//            imageView.animationDuration = 0.1 * count;
//            // 启动动画
//            [imageView startAnimating];
//    }];
//    [self.view addSubview:image];
//
//
//    CAGradientLayer *_gradientLayer = [CAGradientLayer layer];
//    UIColor *startColor = UIColor.redColor;
//    UIColor *endColor   = UIColor.blackColor;
//    _gradientLayer.colors = @[(__bridge id)startColor.CGColor ,(__bridge id)endColor.CGColor];
//    //从左往右
//    _gradientLayer.startPoint = CGPointMake(0.0, 0.0);
//    _gradientLayer.endPoint = CGPointMake(1.0, 0.0);
//    _gradientLayer.frame = self.view.frame;
//    [self.view.layer addSublayer:_gradientLayer];
}

void ReportFunction(id self, SEL _cmd) {
    NSLog(@"This object is %p.",self);
    NSLog(@"Class is %@, and super is %@.",[self class],[self superclass]);
    Class currentClass = [self class];
    for( int i = 1; i < 5; ++i ) {
        NSLog(@"Following the isa pointer %d times gives %p", i, currentClass);
    }
    NSLog(@"NSObject's class is %p", [NSObject class]);
    NSLog(@"NSObject's meta class is %p",object_getClass([NSObject class]));
}

- (NSString *)crashLog
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"crashLog" ofType:@"txt"];
    NSError *err;
    NSString *crashLog = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&err];
    return crashLog;
}

- (void)copyFile
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"crashLog" ofType:@"txt"];
    NSString *cachesDir = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).firstObject;
    NSString *webResourceListFolder = [NSString stringWithFormat:@"%@/%@",cachesDir,@"test"];
    NSString *newPath = [NSString stringWithFormat:@"%@/hhh.txt",webResourceListFolder];
    [[NSFileManager defaultManager] createFileAtPath:newPath contents:[filePath dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
    NSError *err;
    NSString *newPath2 = [newPath stringByAppendingString:@".tmp2"];
    NSLog(@"err:%@", err);
    [[NSFileManager defaultManager] moveItemAtPath:newPath toPath:newPath2 error:&err];
    NSLog(@"err:%@", err);
     [[NSFileManager defaultManager] copyItemAtPath:filePath toPath:newPath error:&err];
    [[NSFileManager defaultManager] moveItemAtPath:newPath toPath:newPath2 error:&err];
    NSLog(@"err:%@", err);
}
- (UIImage *)getImage {

    UIGraphicsBeginImageContextWithOptions(CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height),
                                           NO,
                                           1.0);  //NO，YES 控制是否透明
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    // 生成后的image
    return image;
}

// 根据给定得图片，从其指定区域截取一张新得图片
-(UIImage *)getImageFromImage{
    //大图bigImage
    //定义myImageRect，截图的区域
    CGRect myImageRect = CGRectMake(70, 10, 150, 150);
    UIImage* bigImage= [UIImage imageNamed:@"mm.jpg"];
    CGImageRef imageRef = bigImage.CGImage;
    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, myImageRect);
    CGSize size;
    size.width = 150;
    size.height = 150;
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, myImageRect, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    return smallImage;
}
@end
