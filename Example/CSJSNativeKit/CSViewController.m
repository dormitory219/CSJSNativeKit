//
//  CSViewController.m
//  CSJSNativeKit
//
//  Created by dormitory219 on 04/14/2018.
//  Copyright (c) 2018 dormitory219. All rights reserved.
//

#import "CSViewController.h"
#import "CSJSNativeHelper.h"

#import <objc/runtime.h>

@interface CSViewController ()

@end

@implementation CSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    JSContext *context = [JSContext new];
    NSString *classString = NSStringFromClass([CSJSNativeHelper class]);
    CSJSNativeHelper *helper = [CSJSNativeHelper new];
    helper.context = context;
    helper.property1 = YES;
    helper.property2 = @"Native String";
    context[classString] = helper;
    NSString *js = nil;
    
    //通过 JS 代码调用 Native 代码，Native 进行一大波操作之后得到了一个结果，将这个结果回调给 JavaScript 的方法，就是一个完整的交互过程
    
    
    //一. Native 调用 JavaScript：
    //1.JavaScript 定义 add 函数并且调用，返回结果
    JSValue *value = [context evaluateScript:@" \
                             function add(a, b) { return a + b; } ;\
                             add(1,2) \
                           "];
     NSLog(@"result1:%@",[value toString]);
    
    //2. Native 获取在 JavaScript 定义的 add 函数并且调用，然后穿回到 JavaScript 中执行该 add 函数,再将返回值返回到 Native
    //在 Native 直接通过下标获得这个函数：
    JSValue *func = context[@"add"];
    //并且通过 callWithArguments 来调用他：
    JSValue *result = [func callWithArguments:@[@(1), @(2)]];
    NSLog(@"result2:%@",[result toString]);
    
     
    /* 二. JavaScript  Native 相互交互*/
     
    //1.. JavaScript 中调用全局函数 log :
    //该全局函数 log 在 Native 端实现, 使得 JavaScript 环境中使用 log("") 来输出内容。
    context[@"log"] = ^(NSString *string) {
        NSLog(@"native log:%@", string);
    };
    js = @"log('hello!')";
    [context evaluateScript:js];
    
    //2. JavaScript 中 调用 CSJSNativeHelper 对象 各种方法test1,test2,test3，该对象方法均在 Native 端实现：
    //js中CSJSNativeHelper 调用对象在 Native 端 实现的方法 test1(),test2,test3,test4,get：
    //2.1 函数无传参
    js = @"CSJSNativeHelper.test1();";
    [context evaluateScript:js];
    
    //在 JavaScript 中定义 CSJSNativeHelper 对象一个callWeb方法，该方法为 JavaScript 自己实现
    js = @"CSJSNativeHelper.callWeb = function callWeb(a,b) {return a + b;};";
    value = [context evaluateScript:js];
    
    js = @"CSJSNativeHelper.callWeb(1,2)";
    value = [context evaluateScript:js];
    NSLog(@"test1:callWeb:%@",[value toString]);
    
    //2.2 函数内闭包：Native 通过闭包 log 回调到 JavaScript 环境
    js = @"CSJSNativeHelper.test2(response => log(response));";
    [context evaluateScript:js];
    
    //  => 与下面function相同
    /*
     js = @"CSJSNativeHelper.test2( \
       function(response) { log(response) } \
     );";
     [context evaluateScript:js];
    */
    
    //2.3 函数内传参 + 闭包:
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

    //2.4 函数内传参+函数调用: Native 通过闭包 handler 回调到 JavaScript 环境
    js = @"CSJSNativeHelper.test4( \
    {  \
    message: 'hello', \
    handler: log('test4') \
    }  \
    );";
    [context evaluateScript:js];
    
    //2.5 函数内传参 + 函数调用 + Native 接收 + Native调用 JavaScrip定义并实现的对象方法
    js = @"CSJSNativeHelper.test5( \
    {  \
    message: 'hello', \
    handler: function add(a,b) \
      {  \
        var c = a + b; \
        log('(test5:)' + c);   \
        return c;  \
    } \
    }  \
    );";
    [context evaluateScript:js];
    
    //2.6 异步请求:
    //从 JavaScript 调用 CSJSNativeHelper 对象 get 方法，传参 url 到 Native 去真正调用 get 方法进行 GET 请求 ，Native 请求返回后调用 JavaScript 通过函数传参来的 函数闭包（handler）， 这时穿回 JavaScript 去调用 这个函数闭包(handler) log 函数，最后再穿回 Native 执行了 Native 实现的log函数 调用 NSLog ，打印最后结果。
    js = @"CSJSNativeHelper.get(  \
    {   \
    url:'https://api.forismatic.com/api/1.0/?method=getQuote&lang=en&format=json', \
    handler: response => log('(test6:)' + response)  \
}  \
);";
    [context evaluateScript:js];
    
    //2.6.1 从2.6.0外部再封装一层
    js = @"function CSJSHelper(){  \
      \
} \
    \
    CSJSHelper.getData = function (url,callBack) { \
       CSJSNativeHelper.get2({url:url,callBack:callBack}); \
    }; \
    \
    CSJSHelper.getData(   \
     'https://api.forismatic.com/api/1.0/?method=getQuote&lang=en&format=json',  \
      function(response) {log('(test6.1:)' + response)}  \
    )";
    [context evaluateScript:js];
    
    
    //2.7 Native对象属性:通过 JavaScript 更新 view 的属性
    js = @"var prop = CSJSNativeHelper.property1 ; log('(test7.1:)' + prop)";
    [context evaluateScript:js];
    
    js = @"var prop = CSJSNativeHelper.property2 ; log('(test7.2:)' + prop)";
    [context evaluateScript:js];
    
    js = @"var prop = CSJSNativeHelper.property2; log('(test7.3:)' + prop); prop = 'JavaScript String' ; log('(test7.3:)' + prop)";
    [context evaluateScript:js];
    NSLog(@"%@",helper.property2);
    
    
    // JavaScript 调系统类 Native
    class_addProtocol([UIView class], @protocol(UIViewExport));
    classString = NSStringFromClass([UIView class]);
    context[classString] = self.view;
    js = @"UIView.alpha = 0.8";
    [context evaluateScript:js];
    
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
