//
//  MyWKWebView.m
//  IOSDemo2
//
//  Created by xpyue on 2022/6/27.
//

#import "MyWKWebView.h"
#import <objc/runtime.h>

@interface MyWKWebView () <WKURLSchemeHandler>
@property (nonatomic, strong) NSMutableDictionary *dic;
@end

@implementation MyWKWebView

+ (void)load
{
    Method originalMethod = class_getClassMethod(self, @selector(handlesURLScheme:));
    Method swizzledMethod = class_getClassMethod(self, @selector(qm_handlesURLScheme:));
    method_exchangeImplementations(originalMethod, swizzledMethod);
}

+ (BOOL)qm_handlesURLScheme:(NSString *)urlScheme
{
    if ([urlScheme isEqualToString:@"https"] || [urlScheme isEqualToString:@"http"])
    {
        NSString *string = @"_setLoadResourcesSerially:";
        SEL sel = NSSelectorFromString(string);
        id webViewClass = NSClassFromString(@"WebView");
        if ([webViewClass respondsToSelector:sel])
        {
            BOOL myBoolValue = NO;
            NSMethodSignature* signature = [webViewClass methodSignatureForSelector:sel];
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
            [invocation setTarget: [webViewClass class]];
            [invocation setSelector:sel];
            [invocation setArgument:&myBoolValue atIndex: 2];
            [invocation invoke];
        }
        return NO;
    }
    else
    {
        return [self qm_handlesURLScheme:urlScheme];
    }
}

- (instancetype)initWithFrame:(CGRect)frame configuration:(WKWebViewConfiguration *)configuration
{
//    [configuration setURLSchemeHandler:self forURLScheme:@"https"];
//    [configuration setURLSchemeHandler:self forURLScheme:@"http"];
    self = [super initWithFrame:frame configuration:configuration];
    return self;
}

- (void)webView:(WKWebView *)webView startURLSchemeTask:(id <WKURLSchemeTask>)urlSchemeTask
{
    // 在这里可以对同一资源进行本地缓存，无需要再次访问。
    NSMutableURLRequest *request = urlSchemeTask.request.mutableCopy;
    if ([[request.URL.absoluteString pathExtension] containsString:@"png"]
        || [[request.URL.absoluteString pathExtension] containsString:@"jpg"]
        || [[request.URL.absoluteString pathExtension] containsString:@"gif"]
        || [[request.URL.absoluteString pathExtension] containsString:@"JPEG"]
        || [[request.URL.absoluteString pathExtension] containsString:@"jpeg"])
    {
        request.URL = [NSURL URLWithString:@"https://upload.wikimedia.org/wikipedia/commons/5/58/Shiba_inu_taiki.jpg"];
    }
    else
    {
        request.URL = [NSURL URLWithString:request.URL.absoluteString];
    }
    
    NSLog(@"%@", request.URL.absoluteURL);
    static NSData *imgData;
    static NSURLResponse *resp;
    if ([request.URL.absoluteString isEqualToString:@"https://upload.wikimedia.org/wikipedia/commons/5/58/Shiba_inu_taiki.jpg"]
        && imgData.length)
    {
        // 离线包
        [urlSchemeTask didReceiveResponse:resp];
        [urlSchemeTask didReceiveData:imgData];
        [urlSchemeTask didFinish];
        return;
    }
    NSURLSession* session = [NSURLSession sharedSession];
    NSURLSessionTask* task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if ([request.URL.absoluteString isEqualToString:@"https://upload.wikimedia.org/wikipedia/commons/5/58/Shiba_inu_taiki.jpg"])
        {
            imgData = data;
            resp = response;
        }
        BOOL intV = [(NSNumber *)([self.dic objectForKey:urlSchemeTask.description]) intValue];
        if (intV == 0)
        {
            [urlSchemeTask didReceiveResponse:response];
            [urlSchemeTask didReceiveData:data];
            [urlSchemeTask didFinish];
        }
        
    }];
    [task resume];
    [self.dic setObject:@0 forKey:urlSchemeTask.description];
}

- (void)webView:(WKWebView *)webView stopURLSchemeTask:(id <WKURLSchemeTask>)urlSchemeTask
{
    [self.dic setObject:@1 forKey:urlSchemeTask.description];
}

- (NSMutableDictionary *)dic
{
    if (_dic == nil)
    {
        _dic = [NSMutableDictionary dictionaryWithCapacity:4];
    }
    return _dic;
}
@end
