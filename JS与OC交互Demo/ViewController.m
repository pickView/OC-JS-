//
//  SQViewController.m
//  JS与OC交互Demo
//
//  Created by 周昌旭 on 2017/9/6.
//  Copyright © 2017年 shixueqian. All rights reserved.
//
#import "ViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import <WebKit/WebKit.h>

@interface ViewController ()<WKNavigationDelegate,WKScriptMessageHandler,UIWebViewDelegate>

//webView
//@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (strong ,nonatomic) WKWebView *webView;

@property (weak, nonatomic) IBOutlet UIWebView *wwebView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    WKWebViewConfiguration *configur = [[WKWebViewConfiguration alloc] init];
    WKPreferences *preferences = [[WKPreferences alloc] init];
    configur.preferences = preferences;
    preferences.javaScriptEnabled = YES;
    WKUserContentController *userContentController = [[WKUserContentController alloc]init];
    [userContentController addScriptMessageHandler:self name:@"jsObser"];
    
    configur.userContentController = userContentController;
    
    //webView
    CGRect rect = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height/2);
    _webView = [[WKWebView alloc] initWithFrame:rect configuration:configur];
    _webView.navigationDelegate = self;
    //获取本地html路径
    NSString *path = [[NSBundle mainBundle] pathForResource:@"index.html" ofType:nil];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://jxsbdev.qincailanzi.com/site/test"]];
    [_webView loadRequest:request];
    [self.view addSubview:_webView];
    
    
    
    
    
    
    
    //UIwebView
    self.wwebView.delegate = self;
    NSString *jsPath = [[NSBundle mainBundle] pathForResource:@"index1.html" ofType:nil];
    [self.wwebView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:jsPath]]];

}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    NSLog(@"开始加载");
}
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    NSLog(@"正在加载");
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"网页加载完成");
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    NSLog(@"加载失败");
}

//// 接收到服务器跳转请求之后调用
//- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
//
//
//}
//// 在收到响应后，决定是否跳转
//- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
//    
//    
//}
//// 在发送请求之前，决定是否跳转
//- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
//    
//    
//}

#pragma mark - WKScriptMessageHandler

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    NSLog(@"%@,%@",message.name,message.body);
    
    NSDictionary *dict = message.body;
    NSString *name = dict[@"methodName"];
    NSString *parameter = [NSString stringWithFormat:@"%@",dict[@"goodId"]];
    //如果方法名是我们需要的，那么说明是时候调用原生对应的方法了
    if ([name isEqualToString:@"sayHello"]) {
        if ([self respondsToSelector:@selector(sayHello)]) {
            [self sayHello];
        }
    }else if([name isEqualToString:@"sayHi:"]){
        if ([self respondsToSelector:@selector(sayHi:)]) {
            [self sayHi:parameter];
        }
    }
}


- (void)sayHello{
    NSLog(@"wkWebView------无参");
}

- (void)sayHi:(NSString *)str{
    NSLog(@"wkWebView------%@",str);
}

/*
    UIWebView   交互
 */
-(void)webViewDidFinishLoad:(UIWebView *)webView {
    
    //创建JSContext对象
    JSContext *context = [self.wwebView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    context[@"test"] = ^() {
        NSLog(@"UIWebView------无参");
    };
    context[@"test1"] = ^(NSString *str) {
        NSLog(@"UIWebView------%@",str);
    };

    
}
@end
