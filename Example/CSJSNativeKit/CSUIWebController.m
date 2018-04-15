//
//  CSUIWebController.m
//  CSJSNativeKit_Example
//
//  Created by 余强 on 2018/4/15.
//  Copyright © 2018年 dormitory219. All rights reserved.
//

#import "CSUIWebController.h"
#import "CSJSNativeHelper.h"

@interface CSUIWebController ()<UIWebViewDelegate>

@property (nonatomic,strong) CSJSNativeHelper *helper;

@end

@implementation CSUIWebController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIWebView *web = [[UIWebView alloc]initWithFrame:self.view.frame];
    web.delegate = self;
    [self.view addSubview:web];

    NSString *path = [[NSBundle mainBundle]pathForResource:@"jsDemo.html" ofType:nil];
    [web loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]]];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    JSContext *context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    CSJSNativeHelper *helper  = [[CSJSNativeHelper alloc] init];
    self.helper = helper;
    context[@"CSJSNativeHelper"] = helper;
    helper.context = context;
    context.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
        context.exception = exceptionValue;
        NSLog(@"error：%@", exceptionValue);
    };
    
    
    //Native 调用在 JavaScript 中定义的对象方法
//    NSString *js = @"CSJSNativeHelper.callWeb = function callWeb(parameter) {alert(parameter)};";
//    [context evaluateScript:js];
//    
//    [context evaluateScript:@"CSJSNativeHelper.callWeb('callWeb')"];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

@end
