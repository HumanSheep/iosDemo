//#import "SquareViewController.h"
//
//@interface SquareViewController ()
//
///// 图片
//
//@property (nonatomic, strong) UIImageView *imageView;
//
//@end
//
//@implementation SecondViewController
//
//- (void)viewDidLoad {
//[super viewDidLoad];
//
//[self.view addSubview:self.imageView];
//
//}
//
//#pragma mark - Get方法
//
//-(UIImageView *)imageView {
//if (!_imageView) {
//_imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"image"]];
//
//_imageView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
//
//}
//
//return _imageView;
//
//}
//
//@end
//
//#import "ViewController.h"
//
//#import "SecondViewController.h"
//
//@interface ViewController ()
//
///// 按钮
//
//@property (nonatomic, strong) UIButton *presentButton;
//
//@end
//
//@implementation ViewController
//
//- (void)viewDidLoad {
//[super viewDidLoad];
//
//self.view.backgroundColor = [UIColor grayColor];
//
//[self.view addSubview:self.presentButton];
//
//}
//
//#pragma mark - 点击事件
//
//-(void)persentAction:(UIButton *)button {
//// 充当渐变的背景(可以用自定义view代替)
//
//UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"image"]];
//
//bgImageView.frame = self.view.frame;
//
//[self.view addSubview:bgImageView];
//
//UIBezierPath *maskStartBP = [UIBezierPath bezierPathWithOvalInRect:button.frame];
//
//CGFloat radius = [UIScreen mainScreen].bounds.size.height - 100;
//
//UIBezierPath *maskFinalBP = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(button.frame, -radius, -radius)];
//
//CAShapeLayer *maskLayer = [CAShapeLayer layer];
//
//maskLayer.path = maskFinalBP.CGPath;
//
//maskLayer.backgroundColor = (__bridge CGColorRef)([UIColor whiteColor]);
//
//bgImageView.layer.mask = maskLayer;
//
//CABasicAnimation *maskLayerAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
//
//maskLayerAnimation.fromValue = (__bridge id)(maskStartBP.CGPath);
//
//maskLayerAnimation.toValue = (__bridge id)((maskFinalBP.CGPath));
//
//// 时间
//
//maskLayerAnimation.duration = 5.f;
//
//maskLayerAnimation.delegate = self;
//
//[maskLayer addAnimation:maskLayerAnimation forKey:@"path"];
//
//}
//
///// 结束事件
//
//-(void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag {
//SecondViewController *viewController = [[SecondViewController alloc] init];
//
//[self presentViewController:viewController animated:NO completion:nil];
//
//}
//
///// 开始事件
//
//-(void)animationDidStart:(CAAnimation *)anim {
//NSLog(@"开始事件");
//
//}
//
//#pragma mark - Get方法
//
//-(UIButton *)presentButton {
//if (!_presentButton) {
//_presentButton = [UIButton buttonWithType:UIButtonTypeCustom];
//
//_presentButton.frame = CGRectMake(0, 0, 100, 40);
//
//_presentButton.center = self.view.center;
//
//_presentButton.backgroundColor = [UIColor whiteColor];
//
//[_presentButton setTitle:@"跳转" forState:UIControlStateNormal];
//
//[_presentButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//
//[_presentButton addTarget:self action:@selector(persentAction:) forControlEvents:UIControlEventTouchUpInside];
//
//}
//
//return _presentButton;
//
//}
//
//@end
//————————————————
//版权声明：本文为CSDN博主「Mag1cal」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
//原文链接：https://blog.csdn.net/weixin_32487755/article/details/112810717
