//
//  CSJSNativeHelper.m
//  CSJSNativeKit_Example
//
//  Created by 余强 on 2018/4/14.
//  Copyright © 2018年 dormitory219. All rights reserved.
//

#import "CSJSNativeHelper.h"

@implementation CSJSNativeHelper

- (void)test1
{
    NSLog(@"test1");
   // [self.context evaluateScript:@"callWeb('callWeb')"];
    [self.context evaluateScript:@"CSJSNativeHelper.callWeb('callWeb')"];
}

- (void)test2:(JSValue *)handler
{
    [handler callWithArguments:@[@"test2!"]];
}

- (void)test3:(JSValue *)arguments
{
    NSString *message = [arguments[@"message"] toString];
    JSValue *handler = arguments[@"handler"];
    [handler callWithArguments:@[[NSString stringWithFormat:@"%@,%@",message,@"test3"]]];
}

- (void)test4:(JSValue *)arguments
{
    NSString *message = [arguments[@"message"] toString];
    JSValue *handler = arguments[@"handler"];
    [handler callWithArguments:@[[NSString stringWithFormat:@"%@,%@",message,@"test3"]]];
}

- (void)test5:(JSValue *)arguments
{
    NSString *message = [arguments[@"message"] toString];
    JSValue *handler = arguments[@"handler"];
    JSValue *value =  [handler callWithArguments:@[@(1),@(2)]];
    
    NSLog(@"test5:%@",[value toString]);
    
    //模仿web业务callWeb:
    //1.调全局函数
    value = [self.context evaluateScript:@"add(1,2)"];
    NSLog(@"callWeb1:%@",[value toString]);
    
    //2.调CSJSNativeHelper对象方法
    value = [self.context evaluateScript:@"CSJSNativeHelper.callWeb(1,2)"];
    NSLog(@"callWeb2:%@",[value toString]);
    JSValue *jsNativeHelper = self.context[@"CSJSNativeHelper"];
    value = [jsNativeHelper invokeMethod:@"callWeb" withArguments:@[@1,@2]];
    NSLog(@"callWeb3:%@",[value toString]);
}

- (void)get:(JSValue *)arguments
{
    NSURL *url = [NSURL URLWithString:[arguments[@"url"] toString]];
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        JSValue *handler = arguments[@"handler"];
        [handler callWithArguments:@[string ?: @""]];
    }] resume];
}

- (void)callSystemCamera
{
    NSLog(@"callSystemCamera");
    NSString *js = [NSString stringWithFormat:@"CSJSNativeHelper.callWeb('%@')",@100];
    [self.context evaluateScript:js];
    
}

- (void)callWithJson:(id)json
{
    NSLog(@"callWithJson:%@",json);
    NSString *js = [NSString stringWithFormat:@"CSJSNativeHelper.callWeb('%@')",@100];
    [self.context evaluateScript:js];
}


@end
