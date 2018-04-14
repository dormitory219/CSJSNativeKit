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
}

- (void)test6:(JSValue *)arguments
{
    NSString *message = [arguments[@"message"] toString];
    JSValue *handler = arguments[@"handler"];
    [handler callWithArguments:@[[NSString stringWithFormat:@"%@,%@",message,@"test3"]]];
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

@end
