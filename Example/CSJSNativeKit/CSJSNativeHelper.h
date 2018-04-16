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

@property (nonatomic, assign) BOOL property1;

@property (nonatomic, copy) NSString *property2;

- (void)test1;

- (void)test2:(JSValue *)handler;

- (void)test3:(JSValue *)handler;

- (void)test4:(JSValue *)handler;

- (void)test5:(JSValue *)handler;

- (void)get:(JSValue *)arguments;

- (void)get2:(JSValue *)arguments;

- (void)callSystemCamera;

- (void)callWithJson:(id)json;

@end


@protocol UIViewExport <JSExport>

@property (nonatomic, assign) CGFloat alpha;

@end


@interface CSJSNativeHelper : NSObject<CSJSNativeHelperProtocol>

@property (nonatomic,strong) JSContext *context;

@property (nonatomic, assign) BOOL property1;

@property (nonatomic, copy) NSString *property2;

@end
