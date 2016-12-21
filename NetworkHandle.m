//
//  NetworkHandle.m
//  HDTicket
//
//  Created by 周志荣 on 16/12/14.
//  Copyright © 2016年 周志荣. All rights reserved.
//

#import "NetworkHandle.h"
NSString * StringFromHttpMethod(HDHttpMethod method) {
    switch (method) {
        case Get:
            return @"GET";
        case Post:
            return @"POST";
    }
}

@interface NetworkHandle ()

@property (nonatomic , strong)AFHTTPSessionManager *sessionManager;
@property (nonatomic , strong)NSURLSessionConfiguration *config;
@property (nonatomic , copy)HDSuccessBlock sucBlock;
@property (nonatomic , copy)HDFailureBlock failBlock;

@end
@implementation NetworkHandle

/*
 use defaultSessionConfiguration
 */
-(instancetype)init
{
    return [self initWithConfiguration:nil];
}

/*
 return a handle with a special sessionConfiguration
 */
-(instancetype)initWithConfiguration:(NSURLSessionConfiguration *)configuration
{
    self = [super init];
    if (self) {
        _sessionManager = [[AFHTTPSessionManager alloc]initWithBaseURL:nil sessionConfiguration:configuration];
        _config = configuration;
        NSMutableArray *array = [[NSMutableArray alloc]init];
        [array addObject:@"text/plain"];
        [array addObject:@"text/html"];
        [array addObject:@"text/json"];
        [array addObject:@"application/json"];
        [array addObject:@"text/javascript"];
        NSSet *accepts = [NSSet setWithArray:array];
        _sessionManager.responseSerializer.acceptableContentTypes = accepts;
        _sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
        
//        __weak __typeof(self) weakSelf = self;
        //请求结束之后的回调操作
//        [_sessionManager setTaskDidCompleteBlock:^(NSURLSession * _Nonnull session, NSURLSessionTask * _Nonnull task, NSError * _Nullable error) {
//            __strong __typeof(weakSelf) strongSelf = weakSelf;
            
            
//        }];
    }
    return self;
}


-(void)activateWithURL:(NSURL *)url
               headers:(NSMutableDictionary *)headers
                params:(NSDictionary *)params
                method:(HDHttpMethod)method
               success:(HDSuccessBlock)success
               failure:(HDFailureBlock)failure
{
    
    self.sessionManager.requestSerializer.timeoutInterval=15;
    self.sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
    //如果有请求头
    if (headers) {
        for (NSString *key in headers) {
            [self.sessionManager.requestSerializer setValue:headers[key] forHTTPHeaderField:key];
        }
    }
    
    if (success) {
        _sucBlock = [success copy];
    }
    if (failure) {
        _failBlock = [failure copy];
    }
    
    if(method == Get){
        [self.sessionManager GET:url.absoluteString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            if (success) {
                success(task, responseObject);
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //出错回调
            [self relaunchTask:task error:error];
            
        }];
    }else if(method == Post){
        [self.sessionManager POST:url.absoluteString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            if (success) {
                success(task, responseObject);
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            // 出错回调
           [self relaunchTask:task error:error];
        }];
    }
}


//任务出错回调
-(void)relaunchTask:(NSURLSessionDataTask *)task error:(NSError *)error
{
    //请求失败 正在重试
   NSURLSessionDataTask *newTask = [self.sessionManager.session dataTaskWithRequest:task.currentRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"失败后再次尝试");
       if (error) {
           _failBlock(task,error);
       }else{
           NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
           _sucBlock(task,dic);
       }
    }];
    [newTask resume];
}


@end
