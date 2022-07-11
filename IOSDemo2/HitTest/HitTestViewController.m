//
//  HitTestViewController.m
//  IOSDemo2
//
//  Created by xpyue on 2022/5/2.
//

#import "HitTestViewController.h"
#import "AView.h"
#import "BView.h"
#import "CView.h"

@interface HitTestViewController ()

@property (nonatomic, strong) AView *aView;
@property (nonatomic, strong) BView *bView;
@property (nonatomic, strong) CView *cView;
@property (nonatomic, strong) NSDictionary <NSString *, NSObject *> *dic;
@property (nonatomic, strong) NSMutableDictionary <NSNumber *, NSMutableDictionary *> *res;
@property (nonatomic, strong) NSRecursiveLock *resourceListJsonLock;
@end

@implementation HitTestViewController

- (void)loadView
{
    self.resourceListJsonLock = [[NSRecursiveLock alloc] init];
    [super loadView];
    self.aView = [[AView alloc] initWithFrame:CGRectMake(0.0, 0.0, 400.0, 400.0)];
    self.bView = [[BView alloc] initWithFrame:CGRectMake(0.0, 0.0, 400.0, 100.0)];
    self.cView = [[CView alloc] initWithFrame:CGRectMake(0.0, 300.0, 400.0, 100.0)];
    [self.view addSubview:self.aView];
    self.aView.center = self.view.center;
    [self.aView addSubview:self.bView];
    [self.aView addSubview:self.cView];
    self.dic = @{
        @"ok": [[NSObject alloc] init]
    };
    self.bView.tag = 222;
    UIView *bV = [self.view viewWithTag:222];
    NSMutableDictionary *dic = [@{
        @"page1":@"htmp1",
        @"page2":@"htmp1",
        @"page3":@"htmp1",
        @"page4":@"htmp1",
        @"page5":@"htmp1",
        @"page6":@"htmp1",
        @"page7":@"htmp1",
        @"page8":@"htmp1",
        @"page9":@"htmp1",
        @"page10":@"htmp1",
        @"page11":@"htmp1",
        @"page12":@"htmp1",
        @"page13":@"htmp1",
        @"page14":@"htmp1",
        @"page15":@"htmp1",
        @"page16":@"htmp1",
    } mutableCopy];
    self.res = [[NSMutableDictionary alloc] init];
    for (int i=1; i<=100; i++)
    {
        [self.res setObject:dic forKey:@(i)];
    }
    
     
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"VC 响应");
    [super touchesBegan:touches withEvent:event];    
}

- (id) testddd{
    id xxx = _dic[@"ok"];
    NSLog(@"%@", [xxx valueForKey:@"retainCount"]);
    return xxx;
}
@end
