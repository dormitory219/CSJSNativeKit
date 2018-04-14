//
//  CSViewController.m
//  CSJSNativeKit
//
//  Created by dormitory219 on 04/14/2018.
//  Copyright (c) 2018 dormitory219. All rights reserved.
//

#import "CSViewController.h"
#import "CSJSNativeHelper.h"

@interface CSViewController ()

@end

@implementation CSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *classString = NSStringFromClass([CSJSNativeHelper class]);
    JSContext *context = [JSContext new];
    NSString *js = nil;
    
    //js中定义的全局函数log在native端的实现：使得JS 环境中使用 log("") 来输出内容。
    context[@"log"] = ^(NSString *string) {
        NSLog(@"native log:%@", string);
    };
    js = @"log('hello!')";
    [context evaluateScript:js];
    

    context[classString] = [CSJSNativeHelper new];
    
    //js中CSJSNativeHelper调用对象在native端实现的方法test1(),test2,test3,test4,get：
    //1.函数无传参
    js = @"CSJSNativeHelper.test1();";
    [context evaluateScript:js];
    
    //2.函数内闭包
    js = @"CSJSNativeHelper.test2(response => log(response));";
    [context evaluateScript:js];
    
    //  => 与下面function相同
    /*
     js = @"CSJSNativeHelper.test2( \
       function(response) { log(response) } \
     );";
     [context evaluateScript:js];
    */
    
    //3.函数内传参+闭包
    js = @"CSJSNativeHelper.test3( \
    {  \
     message: 'hello', \
     handler: response => log(response) \
    }  \
    );";
    [context evaluateScript:js];
    
    //  => 与下面function相同
/*
 js = @"CSJSNativeHelper.test3( \
 {  \
 message: 'hello', \
 handler: function(response) { log(response) } \
 }  \
 );";
 [context evaluateScript:js];
 */

    //4.函数内传参+函数调用
    js = @"CSJSNativeHelper.test4( \
    {  \
    message: 'hello', \
    handler: log('test4') \
    }  \
    );";
    [context evaluateScript:js];
    
    //5.函数内传参+函数调用+native接收result
    js = @"CSJSNativeHelper.test5( \
    {  \
    message: 'hello', \
    handler: function(a,b) \
      {  \
        var c = a + b; \
        log('(test5:)' + c);   \
        return c;  \
    } \
    }  \
    );";
    [context evaluateScript:js];
    
    //6.异步请求:
    //从 JavaScript 调用 CSJSNativeHelper 对象 get 方法，传参 url 到 Native 去真正调用 get 方法进行 GET 请求 ，Native 请求返回后调用 JavaScript 通过函数传参来的 函数闭包（handler）， 这时穿回 JavaScript 去调用 这个函数闭包(handler) log 函数，最后再穿回 Native 执行了 Native 实现的log函数 调用 NSLog ，打印最后结果。
    js = @"CSJSNativeHelper.get(  \
    {   \
    url:'https://api.forismatic.com/api/1.0/?method=getQuote&lang=en&format=json', \
    handler: response => log('(test6:)' + response)  \
}  \
);";
    [context evaluateScript:js];
    
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
