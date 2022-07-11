//
//  WebVC.m
//  IOSDemo2
//
//  Created by xpyue on 2022/6/27.
//

#import "WebVC.h"
#import <WebKit/WebKit.h>
#import "MyWKWebView.h"

@interface WebVC ()
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIWebView *webView2;
@end

@implementation WebVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURLRequest *req = [[NSURLRequest alloc]
                         initWithURL:[NSURL URLWithString:@"http://192.168.0.101:8000/index"]];

//    self.webView2 = [[UIWebView alloc] initWithFrame:self.view.bounds];
//    [self.webView2 loadRequest:req];
//    [self.view addSubview:self.webView2];

    self.webView = [[MyWKWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.webView];
    [self.webView loadRequest:req];
    self.navigationItem.title = @"百度";
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
