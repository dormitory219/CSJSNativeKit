//
//  CSJSNativeHelper.h
//  CSJSNativeKit_Example
//
//  Created by 余强 on 2018/4/14.
//  Copyright © 2018年 dormitory219. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

@protocol CSJSNativeHelperProtocol <JSExport>

- (void)test1;

- (void)test2:(JSValue *)handler;

- (void)test3:(JSValue *)handler;

- (void)test4:(JSValue *)handler;

- (void)test5:(JSValue *)handler;

- (void)test6:(JSValue *)handler;

- (void)get:(JSValue *)arguments;


@end


@interface CSJSNativeHelper : NSObject<CSJSNativeHelperProtocol>

@end
