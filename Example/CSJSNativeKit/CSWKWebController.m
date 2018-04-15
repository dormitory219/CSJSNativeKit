//
// CSWKWebController.m
//  CSJSNativeKit
//
//  Created by dormitory219 on 04/14/2018.
//  Copyright (c) 2018 dormitory219. All rights reserved.
//

#import "CSWKWebController.h"
#import <WebKit/WebKit.h>

@interface CSWKWebController ()<WKScriptMessageHandler,WKUIDelegate,WKNavigationDelegate>

@property(nonatomic,strong) WKWebView *webView;

@end

@implementation CSWKWebController

- (void)viewDidLoad {
    [super viewDidLoad];
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.preferences = [[WKPreferences alloc] init];
    config.preferences.minimumFontSize = 30;
    config.preferences.javaScriptEnabled = YES;
    config.preferences.javaScriptCanOpenWindowsAutomatically = NO;
    config.processPool = [[WKProcessPool alloc] init];
    
    // 通过JS与webview内容交互：注入JS对象名称CSJSNativeHelper，当JS通过CSJSNativeHelper来调用时，可以在WKScriptMessageHandler代理中接收到
    config.userContentController = [[WKUserContentController alloc] init];
    [config.userContentController addScriptMessageHandler:self name:@"CSJSNativeHelper"];
    
    WKWebView *webView = [[WKWebView alloc] initWithFrame:self.view.bounds
                                      configuration:config];
    NSURL *path = [[NSBundle mainBundle] URLForResource:@"WKJsDemo" withExtension:@"html"];
    [webView loadRequest:[NSURLRequest requestWithURL:path]];
    [self.view addSubview:webView];
    
    webView.navigationDelegate = self;
    webView.UIDelegate = self;
    self.webView = webView;

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Js alert被拦截
-(void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}

// JavaScript 调 Native
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    NSLog(@"%@",message.body);
    NSDictionary *body = message.body[@"body"];
    NSString *name = message.name;
    NSString *js = nil;
    if ([name isEqualToString:@"CSJSNativeHelper"])
    {
        if ([body isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *json = body[@"json"];
            NSString *type = body[@"type"];
            NSData *data = nil;
            NSString *jsonString = nil;
            if (json)
            {
                data = [NSJSONSerialization dataWithJSONObject:json options:0 error:nil] ;
                jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            }
            if ([type isEqualToString:@"callSystemCamera"])
            {
                //调JavaScript jsAlert函数，add函数
                js = [NSString stringWithFormat:@"jsAlert('%@'),add(1,2)",@"callSystemCamera"];
            }
            else if ([type isEqualToString:@"callWithJson1"])
            {
                //调JavaScript CSJSNativeHelper 对象 callWeb 方法
                js = [NSString stringWithFormat:@"CSJSNativeHelper.callWeb('%@')",jsonString];
            }
            else if ([type isEqualToString:@"callWithJson2"])
            {
                //调JavaScript CSJSNativeHelper 对象 callWeb 方法
                js = [NSString stringWithFormat:@"CSJSNativeHelper.callWeb('%@')",jsonString];
            }
            //Native 调 JavaScript
            [self.webView evaluateJavaScript:js completionHandler:^(id _Nullable responce, NSError * _Nullable error) {
                //JavaScript 返回 函数结果到 Native
                NSLog(@"responce:%@",responce);
            }];
        }
    }
}

@end
